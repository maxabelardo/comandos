USE [master]
GO

;with long_queries as
(   select top 20 
        query_hash, 
        sum(total_elapsed_time) elapsed_time
    from sys.dm_exec_query_stats 
    where query_hash <> 0x0
    group by query_hash
    order by sum(total_elapsed_time) desc
)
select @@servername as [Servidor],
    coalesce(db_name(st.dbid), db_name(cast(pa.value AS INT)), 'Resource') AS [DatabaseName],
    coalesce(object_name(ST.objectid, ST.dbid), '<none>') as [object_name],
    --qs.query_hash,
    qs.total_elapsed_time,
    qs.execution_count,
    cast(total_elapsed_time / (execution_count + 0.0) as money) as average_duration_in_microseconds,
    elapsed_time as total_elapsed_time_for_query,
    SUBSTRING(ST.TEXT,(QS.statement_start_offset + 2) / 2,
        (CASE 
            WHEN QS.statement_end_offset = -1  THEN LEN(CONVERT(NVARCHAR(MAX),ST.text)) * 2
            ELSE QS.statement_end_offset
            END - QS.statement_start_offset) / 2) as sql_text
    --qp.query_plan
from sys.dm_exec_query_stats qs
join long_queries lq
    on lq.query_hash = qs.query_hash
cross apply sys.dm_exec_sql_text(qs.sql_handle) st
cross apply sys.dm_exec_query_plan (qs.plan_handle) qp
outer apply sys.dm_exec_plan_attributes(qs.plan_handle) pa
where pa.attribute = 'dbid'
order by lq.elapsed_time desc,
    lq.query_hash,
    qs.total_elapsed_time desc
option (recompile)





GO


