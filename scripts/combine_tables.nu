#!/usr/bin/env nu
# Script to summarize the modifications per gene and bin into 4 categories
def main [
        per_feature_table: string, # Path to the per feature modifications table
        pre_mrna_table:string, # Path to the pre-mRNA table
        per_read_table: string  # Path to the per read table
        gene_table: string # Path to the gene information table
        output: string  # Path to the output csv
        ] {

        let df_per_feature = polars open -t tsv -d "\t" $per_feature_table
        let df_pre_mrna = polars open -t csv -d "," $pre_mrna_table
        let df_per_read = polars open -t csv -d "," $per_read_table
        let df_gene = polars open -t tsv --no-header -d "\t" $gene_table

        # Need to separate the gene table first column from
        #  chr10_628564-631255:+ LOC101930421
        # into chrom, start, end, strand, name


        # Per feature headers
        #  chrom │  start  │   end   │     name     │ strand │ count_a │ count_valid_a │ percent_a
        # Per read headers
        #   Gene     │ chrom │ Total A │ Gene Start │ Gene Stop │ Min Read Length │ Max Read Length │ Mean Read Length │ Low >=0.25 │ High >=0.75 │ Med >=0.50 │ V Low / Unmodified <0.25
        # Pre-mRNA headers
        #   Gene     │ Chromosome │ Strand │ Intronic │ Non-Intronic


        # Combine on Gene, Chromosome, start end and strand if possible
        let df_combined = $df_per_feature |
            polars join $df_per_read [name chrom] ["Gene" "chrom"] --full |
            polars join $df_pre_mrna [name chrom] [Gene Chromosome] --full |
            polars join $df_gene [name chrom] [column_5 column_1] --full |
            polars select "name" "chrom" "column_2" "column_3" "count_a" "count_valid_a" "percent_a" "Total A" "Min Read Length" "Max Read Length" "Mean Read Length" "Low >=0.25" "High >=0.75" "Med >=0.50" "V Low / Unmodified <0.25" "Intronic" "Non-Intronic" |
            polars collect

        print $df_combined

}
