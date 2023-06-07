
import pandas as pd

run_ids_tab = pd.read_csv("test2.csv", names = ["values"])

run_ids = run_ids_tab.values[:,0]
run_ids = run_ids.tolist()

unique_ids = set(run_ids)

res = {}

for run_id in unique_ids: 

    res[run_id] = run_ids.count(run_id)


foo = 2;

