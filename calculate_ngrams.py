##calculate ngrams : Ce script est conçu pour analyser et extraire des n-grammes pertinents à partir d'un ensemble de données contenant des noms de produits. Le script utilise plusieurs bibliothèques dont “pandas” qui offre des structures de données flexibles et permet de travailler facilement avec des données structurées, “nltk” qui fournit des outils pour travailler avec le texte humain, tels que la tokenisation, la suppression des mots vides, la génération de n-grammes, etc., “re” utilisée pour la manipulation de chaînes de caractères, “itertools”qui fournit des fonctions pour créer des itérateurs pour des boucles efficaces.

import pandas as pd
import nltk
import re
from nltk.corpus import stopwords
from nltk.probability import FreqDist
from nltk.tokenize import word_tokenize
from nltk.util import ngrams
from itertools import chain
import src.config as CONFIG
from src.utils import import_table_from_bq, exporting_tables_to_bq

def find_ngrams(df: pd.DataFrame, top_n_grams: int, ngram_combi: int) -> pd.DataFrame:
    stop_words = set(chain(stopwords.words('english'),
                           stopwords.words('french'),
                           stopwords.words('german'),
                           stopwords.words('italian'),
                           stopwords.words('spanish')))
    word_tokenize = nltk.WordPunctTokenizer().tokenize
    number_regex = re.compile(r'[0-9]')
    alphanumeric_regex = re.compile('^[a-zA-Z0-9]+$')

    grouped_df = df.groupby(['real_breadcrumb', 'pred_breadcrumb'])

    def generate_results():
        for group, group_df in grouped_df:
            group_tokens = []
            for text in group_df["product_name"]:
                text = text.replace('-', ' ')
                tokens = word_tokenize(text)
                for token in tokens:
                    if (token not in stop_words 
                        and not bool(number_regex.search(token))
                        and alphanumeric_regex.match(token)):
                            group_tokens.append(token)
                group_tokens.append('nonstopwordseparator')

            for i in range(1, ngram_combi+1):
                ngram_tokens = list(ngrams(group_tokens, i))
                ngram_tokens = [token for token in ngram_tokens if all(len(word) > 2 if i == 1 else len(word) > 1 for word in token) and 'nonstopwordseparator' not in token]

                ngram_freq = FreqDist(ngram_tokens)
                total_top_freq = 0
                other_freq = 0
                
                for rank, (ngram, freq) in enumerate(ngram_freq.most_common(), start=1):
                    if rank <= top_n_grams:
                        yield group[0], group[1], '.*'.join(ngram), freq, i
                        total_top_freq += freq
                    else:
                        other_freq += freq

                if other_freq > 0:
                    yield group[0], group[1], '*', other_freq, i
    
    result_df = pd.DataFrame(generate_results(), columns=['real_breadcrumb', 'pred_breadcrumb', 'n_gram', 'freq', 'n'])
    return result_df




def run() -> None:

    table_for_metrics = import_table_from_bq(
        f"SELECT * FROM {CONFIG.BIGQUERY_PROJECTID}.datascience_machine_learning.ml_monitoring_results"
    )
    table_n_grams = find_ngrams(table_for_metrics, CONFIG.TOP_N_GRAMS, CONFIG.NGRAM_COMBI)
    exporting_tables_to_bq("datascience_machine_learning", table_n_grams, "ml_monitoring_ngrams")

