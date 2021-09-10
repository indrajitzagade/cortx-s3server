#!/bin/bash
#
# Copyright (c) 2020 Seagate Technology LLC and/or its Affiliates
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# For any questions about this software or licensing,
# please email opensource@seagate.com or cortx-questions@seagate.com.
#

source ./config.sh
source ./env.sh
source ./sh/functions.sh

set -e

add_separator "Creating OpenLDAP POD"

mkdir -p /var/lib/ldap
echo "ldap:x:55:" >> /etc/group
echo "ldap:x:55:55:OpenLDAP server:/var/lib/ldap:/sbin/nologin" >> /etc/passwd
chown -R ldap.ldap /var/lib/ldap

cat ./k8s-blueprints/openldap-pv.yaml.template \
  | sed "s/<vm-hostname>/${HOST_FQDN}/" \
  > ./k8s-blueprints/openldap-pv.yaml

kubectl apply -f ./k8s-blueprints/openldap-pv.yaml
kubectl apply -f ./k8s-blueprints/openldap-stateful.yaml

yum install -y openldap-clients

# Find LDAP cluster IP
add_separator Listing k8s LDAP service
kubectl get svc | grep 'NAME\|ldap'
set +x
echo
read -p "Copy the CLUSTER-IP value for LDAP service:" var
set -x
OPENLDAP_SVC="$var"


# apply .ldif files

ldapadd -x -D "cn=admin,dc=seagate,dc=com" -w ldapadmin -f ldif/ldap-init.ldif -H "ldap://$OPENLDAP_SVC"
ldapadd -x -D "cn=admin,dc=seagate,dc=com" -w ldapadmin -f ldif/iam-admin.ldif -H "ldap://$OPENLDAP_SVC"
ldapmodify -x -a -D cn=admin,dc=seagate,dc=com -w ldapadmin -f ldif/ppolicy-default.ldif -H "ldap://$OPENLDAP_SVC"

set +x

add_separator SUCCESSFULLY CREATED OPENLDAP POD
