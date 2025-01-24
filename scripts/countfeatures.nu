# countfeatures.nu
def main [file: string, output: string] {
    polars open -t tsv --no-header -d "\t" $file | 
        polars sort-by column_1 column_2 | 
        polars unique --subset [column_1 column_4 column_6] |
        polars group-by column_1 column_6 |
        polars agg [
            (polars col column_4 | polars count | polars as "unique_genes")
        ] |
        polars rename [column_1 column_6 unique_genes] ["Chromosome" "Strand" "Unique Genes"] |
        polars collect | 
        polars save $output 
}
