EXEC sp_resetstatus [PRD_OT_WEMSYS_DB];
ALTER DATABASE [PRD_OT_WEMSYS_DB] SET EMERGENCY
DBCC checkdb([PRD_OT_WEMSYS_DB])
ALTER DATABASE [PRD_OT_WEMSYS_DB] SET SINGLE_USER WITH ROLLBACK IMMEDIATE
DBCC CheckDB ([PRD_OT_WEMSYS_DB], REPAIR_ALLOW_DATA_LOSS)
ALTER DATABASE [PRD_OT_WEMSYS_DB] SET MULTI_USER
