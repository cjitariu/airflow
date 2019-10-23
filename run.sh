oc new-project airflow
oc apply -f postgres
sleep 15
oc apply -f secrets/
oc apply -f configmaps/
oc apply -f rbac/
oc apply -f sheduler/
oc apply -f web/

AIRFLOW_ROUTE=$(oc get routes/airflow-web -o=jsonpath='{.spec.host}')

echo "Airflow is available at http://${AIRFLOW_ROUTE}"
