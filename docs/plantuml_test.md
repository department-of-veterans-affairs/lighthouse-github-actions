```plantuml
package "Local Computer" {
        component LC as "VS Code remote"
    }
cloud "Microsoft Azure" {
    package Codespaces {
        package "Minikube Devcontainer" {
            package "Local Cluster" {
                component [IGW] as "Istio Gateway"
                package "BE Pod" {
                    component BEC as "BE Container"
                    component BESC as "Istio-proxy"
                    BEC -d- BESC
                }
                package "FE Pod" {
                    component FEC as "FE Container"
                    component FESC as "Istio-proxy"
                    FEC -d- FESC
                }
                package "Postgres Pod" {
                    component PGEC as "Postgres Container"
                    component PGESC as "Istio-proxy"
                    PGEC -d- PGESC
                }
                IGW -r-> BESC
                IGW -r-> FESC
                IGW -r-> PGESC
            }
        }
    }
}
[LC] -d-> Codespaces
```
