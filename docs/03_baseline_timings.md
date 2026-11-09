# Phase 3: Baseline Query Performance Report

## 1. Overview

This report documents the baseline performance of the Practo Doctor Appointments database before applying any additional indexing optimizations.

The benchmark evaluates the execution performance of 30 SQL workload queries:

- **25 READ queries:** R01–R25
- **5 WRITE queries:** W01–W05

The benchmark was executed using PostgreSQL and the project's benchmark script.

## 2. Benchmark Methodology

The following benchmark command was executed from the project root:

```bash
./benchmarks/run_benchmark.sh practo_db before
```

Benchmark details:

- Database: `practo_db`
- Schema: `practo`
- Workload: `queries/workload_30.sql`
- Runs per query: 3 (default)
- Execution analysis: `EXPLAIN (ANALYZE, BUFFERS)`
- WRITE queries: Executed inside transactions and rolled back.
- Metrics collected: Average, median, minimum and maximum execution time.

The benchmark results were saved in:

```text
benchmarks/results/before/
```

The directory contains individual execution plan files for all 30 queries and a consolidated `summary.csv`.

## 3. Baseline Performance Results

All execution times are in milliseconds (ms).

| Query | Type | Average (ms) | Median (ms) | Min (ms) | Max (ms) |
|---|---|---:|---:|---:|---:|
| R01 | READ | 2.320 | 2.011 | 1.647 | 3.302 |
| R02 | READ | 0.264 | 0.265 | 0.245 | 0.283 |
| R03 | READ | 9.106 | 8.778 | 8.178 | 10.362 |
| R04 | READ | 6.406 | 6.369 | 6.275 | 6.575 |
| R05 | READ | 5.011 | 4.881 | 4.771 | 5.381 |
| R06 | READ | 0.021 | 0.020 | 0.020 | 0.023 |
| R07 | READ | 0.259 | 0.041 | 0.039 | 0.698 |
| R08 | READ | 18.887 | 18.886 | 18.628 | 19.146 |
| R09 | READ | 7.518 | 7.495 | 7.366 | 7.694 |
| R10 | READ | 18.523 | 16.476 | 16.331 | 22.761 |
| R11 | READ | 15.845 | 15.825 | 15.724 | 15.987 |
| R12 | READ | 22.047 | 21.942 | 21.783 | 22.416 |
| R13 | READ | 2.415 | 2.444 | 2.317 | 2.485 |
| R14 | READ | 17.373 | 17.308 | 17.263 | 17.548 |
| R15 | READ | 19.449 | 19.302 | 19.178 | 19.868 |
| R16 | READ | 8.828 | 8.838 | 8.711 | 8.936 |
| R17 | READ | 40.009 | 39.938 | 39.584 | 40.505 |
| R18 | READ | 3.885 | 3.950 | 3.668 | 4.037 |
| R19 | READ | 4367.339 | 4353.562 | 4331.229 | 4417.225 |
| R20 | READ | 7.748 | 7.606 | 7.564 | 8.073 |
| R21 | READ | 8.092 | 8.115 | 7.727 | 8.433 |
| R22 | READ | 32.083 | 31.947 | 31.659 | 32.642 |
| R23 | READ | 0.023 | 0.022 | 0.020 | 0.027 |
| R24 | READ | 20.270 | 20.375 | 19.726 | 20.710 |
| R25 | READ | 18.257 | 18.414 | 17.926 | 18.431 |
| W01 | WRITE | 0.523 | 0.499 | 0.492 | 0.578 |
| W02 | WRITE | 6.431 | 6.375 | 6.351 | 6.567 |
| W03 | WRITE | 0.130 | 0.121 | 0.116 | 0.152 |
| W04 | WRITE | 8.568 | 8.525 | 8.448 | 8.731 |
| W05 | WRITE | 6.491 | 6.489 | 6.426 | 6.558 |

## 4. Execution Plan Observations

The execution plans show that PostgreSQL uses a combination of Sequential Scans and Index Scans.

### Existing Index Usage

Several queries already benefit from existing indexes:

- R06 uses `patients_phone_key`.
- R23 uses `doctors_registration_no_key`.
- R02 and R03 use `pk_doctor_schedules`.
- R07 uses `prescriptions_appointment_id_key` and `pk_prescription_items`.

These queries demonstrate the benefit of indexed lookups for suitable conditions.

### Sequential Scan Observations

Several queries perform sequential scans on frequently accessed tables, particularly:

- `appointments`
- `patients`
- `clinics`
- `doctor_schedules`
- `doctor_specializations`
- `specializations`

Sequential scans are not necessarily inefficient. Their usefulness depends on table size, selectivity, and the number of rows accessed.

## 5. Key Baseline Findings

### Slowest Queries

The following queries have the highest average execution times:

| Query | Average Execution Time |
|---|---:|
| R19 | 4367.339 ms |
| R17 | 40.009 ms |
| R22 | 32.083 ms |
| R12 | 22.047 ms |
| R24 | 20.270 ms |

R19 is significantly slower than the remaining workload and is the primary candidate for further investigation.

### Fastest Queries

| Query | Average Execution Time |
|---|---:|
| R06 | 0.021 ms |
| R23 | 0.023 ms |
| W03 | 0.130 ms |
| R07 | 0.259 ms |
| R02 | 0.264 ms |

These queries already demonstrate very low execution times.

### General Observations

1. R19 has a considerably higher execution time than the other queries.
2. R17 and R22 are additional candidates for performance investigation.
3. Existing indexes are being utilized by several queries.
4. Sequential scans are common in queries involving the appointments table.
5. WRITE queries generally have lower execution times than the slowest READ queries.

## 6. Baseline Conclusion

The baseline benchmark successfully measured all 30 workload queries before additional indexing optimizations.

The results provide a reference point for evaluating the effectiveness of future database optimizations.

The next phase will investigate expensive queries, identify suitable indexing opportunities, apply selected indexes, and execute the same workload again.

The optimized results will be compared against this baseline to evaluate changes in query execution performance.

**Baseline results:** `benchmarks/results/before/summary.csv`

**Execution plans:** `benchmarks/results/before/`
