import pandas as pd
import sqlite3

# parameters
db_file = "/Users/vinh/Downloads/vnm_data.sqlite"
table_name = "daily_data"
excel_file = "/Users/vinh/Downloads/Sample Daily Data.xlsx"
sheet = "Sheet1"
date_type_pks = ["Date"]
other_pks = ["UCell Id"]

primary_keys = date_type_pks + other_pks

def get_db_connection():
    return sqlite3.connect(db_file)


def build_sql_fields(pks: list[str], surround_by: str = None):
    if surround_by is None:
        surround_by = ''
    res = ''
    for pk in pks:
        res += surround_by + pk + surround_by + ','
    return res[:-1]


def get_existing_pk_data(tbl_name: str, pks: list[str]):
    conn = get_db_connection()
    cur = conn.cursor()
    try:
        sql = f"""
            select {build_sql_fields(pks, surround_by='"')} from {tbl_name};
        """
        cur.execute(sql)
        epk = cur.fetchall()
        if len(pks) == 1:
            return [x for x, in epk]
        else:
            return epk
    except:
        return []


def save_df_to_db(df: pd.DataFrame, tbl_name: str, pks: list[str] = None, behavior: str = 'fresh'):
    if behavior not in ['replace', 'append', 'fresh']:
        raise ValueError('wrong behavior')
    conn = get_db_connection()
    if behavior == 'append':
        # drop existing record by pks before append to existing table
        epk = get_existing_pk_data(tbl_name, pks)
        if len(epk) != 0:
            if len(epk) == 1:
                df = df[~df.index.isin(epk)]
            else:
                df = df[~df.index.to_flat_index().isin(epk)]

    print(f'{len(df)} records saved to table {tbl_name} by {behavior}')
    if behavior == 'fresh':
        conn.execute(f'''
            delete from {tbl_name}
        ''')
        df.to_sql(tbl_name, conn, if_exists='append')
    else:
        df.to_sql(tbl_name, conn, if_exists=behavior)

    return df


def main():
    print(f"loading data from {excel_file}")
    df = pd.read_excel(excel_file, sheet)

    # must convert date type to string to be able to find existing records
    for k in date_type_pks:
        df[k] = df[k].astype(str)

    df.set_index(keys=primary_keys, inplace=True)

    print(f"saving data to database {db_file}")
    save_df_to_db(df, table_name, primary_keys, behavior="append")
    print("Success!")


main()
