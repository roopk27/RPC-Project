/*
 * date.x - Sun RPC interface for remote system monitoring.
 
 */

struct rpcstat_request {
    /*
     * option:
     *  1 = Date
     *  2 = Time
     *  3 = Date+Time
     *  4 = CPU usage
     *  5 = Memory usage
     *  6 = Load (1-min) + running/total procs
     *  7 = Logged-in users
     *  8 = All stats
     */
    int option;
};

struct rpcstat_stats {
    /* Filled depending on option; for option=8 all fields are filled. */
    string timestr<128>;     /* formatted date/time string */
    double cpu_percent;      /* CPU utilization percentage */
    double mem_percent;      /* memory used percentage */
    double load1;            /* 1-minute load average */
    int procs_running;       /* running processes */
    int procs_total;         /* total processes */
    int user_count;          /* number of logged-in user sessions */
    string users<512>;       /* comma-separated list of usernames */
};

program RPCSTAT_PROG {
    version RPCSTAT_VERS {
        rpcstat_stats RPCSTAT(rpcstat_request) = 1;
    } = 1;
} = 0x31234567;
