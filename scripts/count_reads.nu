#!/usr/bin/env nu
# Script to summarize modifications per gene into two categories:
# Intronic and Non-Intronic reads, and combine them into a final summary.

def main [
    intronic_reads: string,       # Path to the intronic reads TSV file
    non_intronic_reads: string,   # Path to the non-intronic reads TSV file
    output: string                # Path to the output (unused in current version)
] {

    # ─────────────────────────────────────────────────────────────
    # Initialize intronic_summary with an empty DataFrame
    # Columns must match expected types to avoid schema mismatches during concat
    mut intronic_summary = ([
        {
            "Gene": "",            # String: Gene name
            "Chromosome": "",      # String: Chromosome name
            "Gene Start": 0,       # Int: Start position of the gene
            "Gene Stop": 0,        # Int: End position of the gene
            "Strand": "",          # String: '+' or '-' strand
            "Phase": 0,            # Int: Gene phase
            "Read Counts": 0,      # Int (cast later): number of reads
            "Type": "Intronic"             # String: "Intronic" or "Non-Intronic"
        }
    ] | polars into-df --as-columns)

    # ─────────────────────────────────────────────────────────────
    # Try reading and processing intronic reads file
    try {
        # 1. Read TSV without headers
        # 2. Select relevant columns (by index)
        # 3. Rename columns to human-readable names
        # 4. Convert to lazy DF for optimization
        # 5. Deduplicate on Gene and Read ID
        # 6. Group by Gene and aggregate first values + read count
        # 7. Add "Type" column to label this as "Intronic"
        # 8. Cast Read Counts column to i64 for consistency
        $intronic_summary = polars open --no-header -t tsv -d "\t" $intronic_reads |
            polars select column_1 column_2 column_3 column_4 column_5 column_6 column_16 |
            polars rename [
                column_1 column_2 column_3 column_4 column_5 column_6 column_16
            ] [
                "Chromosome" "Gene Start" "Gene Stop" "Gene" "Phase" "Strand" "Read ID"
            ] |
            polars into-lazy |
            polars unique --subset ["Gene" "Read ID"] |
            polars group-by Gene |
            polars agg [
                (polars col "Chromosome" | polars first | polars as "Chromosome"),
                (polars col "Gene Start" | polars first | polars as "Gene Start"),
                (polars col "Gene Stop" | polars first | polars as "Gene Stop"),
                (polars col "Strand" | polars first | polars as "Strand"),
                (polars col "Phase" | polars first | polars as "Phase"),
                (polars col "Read ID" | polars count | polars as "Read Counts")
            ] |
            polars with-column (polars lit "Intronic" | polars as "Type") |
            polars with-column (
                (polars col "Read Counts" | polars cast i64) |
                polars as "Read Counts"
            )
    } catch {
        |err| $err.msg
        print "Intronic reads file is empty"
    }

    # ─────────────────────────────────────────────────────────────
    # Initialize non_intronic_summary with the same empty schema
    mut non_intronic_summary = ([
        {
            "Gene": "",
            "Chromosome": "",
            "Gene Start": 0,
            "Gene Stop": 0,
            "Strand": "",
            "Phase": 0,
            "Read Counts": 0,
            "Type": "Non-Intronic"
        }
    ] | polars into-df --as-columns)

    # ─────────────────────────────────────────────────────────────
    # Try reading and processing non-intronic reads file
    try {
        $non_intronic_summary = polars open --no-header -t tsv -d "\t" $non_intronic_reads |
            polars select column_1 column_2 column_3 column_4 column_5 column_6 column_16 |
            polars rename [
                column_1 column_2 column_3 column_4 column_5 column_6 column_16
            ] [
                "Chromosome" "Gene Start" "Gene Stop" "Gene" "Phase" "Strand" "Read ID"
            ] |
            polars into-lazy |
            polars unique --subset ["Gene" "Read ID"] |
            polars group-by Gene |
            polars agg [
                (polars col "Chromosome" | polars first | polars as "Chromosome"),
                (polars col "Gene Start" | polars first | polars as "Gene Start"),
                (polars col "Gene Stop" | polars first | polars as "Gene Stop"),
                (polars col "Strand" | polars first | polars as "Strand"),
                (polars col "Phase" | polars first | polars as "Phase"),
                (polars col "Read ID" | polars count | polars as "Read Counts")
            ] |
            polars with-column (polars lit "Non-Intronic" | polars as "Type") |
            polars with-column (
                (polars col "Read Counts" | polars cast i64) |
                polars as "Read Counts"
            )
    } catch {
        |err| $err.msg
        print "Non-intronic reads file is empty"
    }

    # ─────────────────────────────────────────────────────────────
    # Try to sort intronic summary by read counts (descending)
    try {
        $intronic_summary = $intronic_summary |
           polars sort-by ["Read Counts"] -r [true]
    } catch {
        |err| $err.msg
        print "Intronic reads file is empty"
    }

    # ─────────────────────────────────────────────────────────────
    # Try to sort non-intronic summary by read counts (descending)
    try {
        $non_intronic_summary = $non_intronic_summary |
           polars sort-by ["Read Counts"] -r [true]
    } catch {
        |err| $err.msg
        print "Non-intronic reads file is empty"
    }

    # ─────────────────────────────────────────────────────────────
    # Concatenate both summaries into a single DataFrame
    # Ensure schemas match by using consistent initialization and casting
    let df_combined = $intronic_summary |
        polars concat $non_intronic_summary |  # Safe concat now that types match
        polars filter ((polars col Gene) != "") |  # Filter out empty genes
        polars collect                       # Realize the lazy frame

    # ─────────────────────────────────────────────────────────────
    # Print the final combined summary
    print $df_combined

    # ─────────────────────────────────────────────────────────────
    # Save the final combined summary to the output path
    $df_combined | polars save $output
}
