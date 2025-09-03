#! /usr/bin/python3.10

import pandas as pd
import numpy as np
import sys
pd.options.mode.chained_assignment = None  # default='warn'

##Arguments
#input tsv
tsv_file_path=sys.argv[1]
#list of column kept for output
col_list_path=sys.argv[2]
#output path
output_path=sys.argv[3]
#gene_lists path
gene_lists_path = sys.argv[4]


##gene lists
Cancer_genes_path = gene_lists_path + 'CG_list_avril_2018.txt'
Cancer_predisposition_genes_path = gene_lists_path + 'CPG_list_avril_2018.txt'
aml_genes_path = gene_lists_path + 'aml_gene_list.txt'
brain_tumor_genes_path = gene_lists_path + 'brain_tumor_list_ref_ens.csv'
all_genes_path = gene_lists_path + 'all_gene_list_ref_ens.csv'
ensembl_path= gene_lists_path + 'ensembl_gene'
Leukemia_som_path = gene_lists_path + 'Leukemia_som_clinV3_genes'
Solid_germ_path = gene_lists_path + 'Solid_germ_clinV2_genes'
Hemato_germ_path = gene_lists_path + 'Hemato_germ_clinV2_genes'
Solid_som_path = gene_lists_path + 'Solid_som_clinV2_genes'


def annotate(df):
    def add_End(df):
        df['End'] = df.apply(lambda x: (x["POS"] + (len(x['REF']) - 1)), axis=1)

        return df
    
    def add_Cancer_genes(df):
        df_Cancer_genes_raw = pd.read_csv(Cancer_genes_path, sep='\t', header = None)
        df_Cancer_genes = df_Cancer_genes_raw.iloc[:, [1,8]] 
        df_Cancer_genes.columns = ['ensemblID', 'Cancer_genes']

        df = df.merge(df_Cancer_genes, how = 'left', on = 'ensemblID')

        return df

    def add_Cancer_predisposition_genes(df):
        df_Cancer_predisposition_genes_raw = pd.read_csv(Cancer_predisposition_genes_path, sep='\t', header = None)
        df_Cancer_predisposition_genes = df_Cancer_predisposition_genes_raw.iloc[:, [1,8]] 
        df_Cancer_predisposition_genes.columns = ['ensemblID', 'Cancer_predisposition_genes']

        df = df.merge(df_Cancer_predisposition_genes, how = 'left', on = 'ensemblID')   
        
        return df

    def add_aml_genes(df):
        with open(aml_genes_path) as f:
            aml_genes = f.read()
        aml_genes = aml_genes.split("\n")

        df['aml_genes'] = df['Gene.refGene'].apply(lambda x : 'aml gene list' if x in aml_genes else np.nan )
        
        return df   
    
    def add_variant_damaging_score(df):
        def count_all_damage(row):
            def count_damage(pred_type, verified, positive, verified_values, positive_values):
                if row[pred_type] in verified_values:
                    verified += 1
                if row[pred_type] in positive_values:
                    positive +=1
                return verified,positive
            
            verified = 0
            positive = 0
            verified,positive = count_damage("SIFT_pred", verified, positive,["D","T"],["D"])
            verified,positive = count_damage("Polyphen2_HDIV_pred", verified, positive,["B","P","D"],["D","P"])
            verified,positive = count_damage("Polyphen2_HVAR_pred", verified, positive,["B","P","D"],["D","P"])
            verified,positive = count_damage("RadialSVM_pred", verified, positive, ["D","T"],["D"])
            verified,positive = count_damage("LRT_pred", verified, positive,["D","T"],["D"])
            verified,positive = count_damage("LR_pred", verified, positive,["D","T"], ["D"])
            verified,positive = count_damage("MutationTaster_pred", verified, positive,["A","D","N","P"], ["A","D"])
            verified,positive = count_damage("MutationAssessor_pred", verified, positive,["H","M","L","N"],["H","M"])
            verified,positive = count_damage("FATHMM_pred", verified, positive,["D","T"],["D"])
            if verified > 0:
                variant_damaging_score = positive / verified
            else:
                variant_damaging_score = -1
            return variant_damaging_score
        
        df['variant_damaging_score'] = df.apply(count_all_damage, axis=1)
        
        return df
    
    def split_AD(df):
        df[['RPM', 'VPM']] = df['AD'].str.split(',', n = 1, expand = True) 

        return df

    def add_brain_tumor_genes(df):
        df_brain_tumor_genes = pd.read_csv(brain_tumor_genes_path, sep='\t', header = None)
        brain_tumor_genes = df_brain_tumor_genes[1].to_list()
        
        df['brain_tumor_genes'] = df['ensemblID'].apply(lambda x : 'brain tumor gene list' if x in brain_tumor_genes else np.nan )

        return df  

    def add_all_genes(df):
        df_all_genes = pd.read_csv(all_genes_path, sep='\t', header = None)
        all_genes = df_all_genes[1].to_list()
        
        df['all_genes'] = df['ensemblID'].apply(lambda x : 'all gene list' if x in all_genes else np.nan )

        return df

    def add_ensembl(df):
        df_ensembl = pd.read_csv(ensembl_path, sep='\t', header = None)
        df_ensembl.columns = [ 'ensemblID', 'Gene.refGene']

        df = df.merge(df_ensembl, how = 'left', on = 'Gene.refGene')  

        return df

    def add_Hemato_germ(df):
        df_Hemato_germ = pd.read_csv(Hemato_germ_path, sep=',', header = None)
        Hemato_germ = df_Hemato_germ[1].to_list()
        
        df['Hemato_germ_clin_genes'] = df['ensemblID'].apply(lambda x : 'Hemato germ clin genes list' if x in Hemato_germ else np.nan )

        return df

    def add_Leukemia_som(df):
        df_Leukemia_som = pd.read_csv(Leukemia_som_path, sep=',', header = None)
        Leukemia_som = df_Leukemia_som[1].to_list()
        
        df['Leukemia_som_clin_genes'] = df['ensemblID'].apply(lambda x : 'Leukemia som clin genes list' if x in Leukemia_som else np.nan )

        return df
    
    def add_Solid_germ(df):
        df_Solid_germ = pd.read_csv(Solid_germ_path, sep=',', header = None)
        Solid_germ = df_Solid_germ[1].to_list()
        
        df['Solid_germ_clin_genes'] = df['ensemblID'].apply(lambda x : 'Solid germ clin genes list' if x in Solid_germ else np.nan )

        return df

    def add_Solid_som(df):
        df_Solid_som = pd.read_csv(Solid_som_path, sep=',', header = None)
        Solid_som = df_Solid_som[1].to_list()
        
        df['Solid_som_clin_genes'] = df['ensemblID'].apply(lambda x : 'Solid som clin genes list' if x in Solid_som else np.nan )

        return df
    
    #adds columns
    df = add_End(df)
    df = add_ensembl(df)
    df = add_Cancer_genes(df)
    df = add_Cancer_predisposition_genes(df)
    df = add_aml_genes(df)
    df = add_variant_damaging_score(df)
    df = split_AD(df)
    df = add_brain_tumor_genes(df)
    df = add_all_genes(df)
    df = add_Hemato_germ(df)
    df = add_Leukemia_som(df)
    df = add_Solid_germ(df)
    df = add_Solid_som(df)
    return df

def format(df):
    def ignore_comments(list):
        new_list=[]
        for ele in list:
            if not '#' in ele:
                new_list.append(ele)
        return new_list

    def remove_empty(col_list):
        new_list=[]
        for ele in col_list:
            if not ele == '':
                new_list.append(ele)
        return new_list
    
    #rename columns to csv standard
    df = df.rename(columns={'#CHROM': 'Chr'})
    df = df.rename(columns={'POS': 'Start'})
    df = df.rename(columns={'AF': 'FREQ'})
    
    #removes chr in chromosome column
    df['Chr'] = df['Chr'].str.replace('chr', '', regex=True)

    #retrieve and formats list of columns from file
    col_list = pd.read_csv(col_list_path, header=None)
    col_list = col_list.iloc[:,0].to_list()
    col_list = ignore_comments(col_list)
    col_list = remove_empty(col_list)

    #creates new df with columns from file
    df_final = pd.DataFrame()

    for col in col_list:
        df_final[col] = df[col]   

    return df_final

def filter(df):
    #Only keep exonic and splicing
    df_filtered = df[df['Func.refGene'].str.contains('exonic|splicing')]

    return df_filtered  

def main():
    df = pd.read_csv(tsv_file_path, sep='\t')
    df_filtered = filter(df)
    df_annotated = annotate(df_filtered)
    df_final = format(df_annotated)
    df_final.to_csv(output_path, sep='\t', na_rep = '.', index = False)

if __name__ == "__main__":
    main()
