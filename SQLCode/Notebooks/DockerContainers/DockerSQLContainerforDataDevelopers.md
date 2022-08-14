---
marp: true
paginate: true
background: #fff
---

![bg right:55% 90%](https://user-images.githubusercontent.com/15751283/131569435-34a519eb-5215-4846-ab3c-bf9ee22058db.png)
# **Docker**
### **SQL Containers for Data Professionals**

---

![bg](https://user-images.githubusercontent.com/15751283/131571995-d0e1d8b1-f899-43d8-a885-a42c05232793.png)
# What is Docker Container?

>Docker is an open platform for developing, shipping, and running applications. Docker enables you to separate your applications from your infrastructure so you can deliver software quickly. With Docker, you can manage your infrastructure in the same ways you manage your applications. By taking advantage of Docker’s methodologies for shipping, testing, and deploying code quickly, you can significantly reduce the delay between writing code and running it in production.

---

![bg](https://user-images.githubusercontent.com/15751283/131571995-d0e1d8b1-f899-43d8-a885-a42c05232793.png)

# Docker Architecture

>Docker uses a client-server architecture. The Docker client talks to the Docker daemon, which does the heavy lifting of building, running, and distributing your Docker containers. The Docker client and daemon can run on the same system, or you can connect a Docker client to a remote Docker daemon. The Docker client and daemon communicate using a REST API, over UNIX sockets or a network interface. Another Docker client is Docker Compose, that lets you work with applications consisting of a set of containers.  

---
![bg](https://user-images.githubusercontent.com/15751283/131571995-d0e1d8b1-f899-43d8-a885-a42c05232793.png)

![Width:900px height:550px](https://user-images.githubusercontent.com/15751283/131576182-9938b866-b162-42b3-96d7-e9cd6b83c10c.png)

---

![bg](https://user-images.githubusercontent.com/15751283/131571995-d0e1d8b1-f899-43d8-a885-a42c05232793.png)


![Width:900px height:550px](https://user-images.githubusercontent.com/15751283/131578980-0189c1df-df14-47cc-85d2-739c8c404318.png)

---

![bg](https://user-images.githubusercontent.com/15751283/131571995-d0e1d8b1-f899-43d8-a885-a42c05232793.png)

# Container for SQL Developers

---

![bg](https://user-images.githubusercontent.com/15751283/131571995-d0e1d8b1-f899-43d8-a885-a42c05232793.png)

Probably right now you are asking, why we need to use SQL containers? If we have LAB or Dev environments, or local SQL Server instances. 

1. **Savings:** SQL developers adopting containers can help to reduce between 8x to 10x the number of SQL Servers hosted in our networks, reducing the licenses costs for the company.  
1. **Speed:** This is one of the most important features of the containers. We can deploy or mount a 1TB database server in a few minutes, in comparison to installing, setup, and restore a VM or Physical server. 
1. **New code or versions of the databases:** We can incorporate into the images changes not affecting other environments, and each developer can work on the version that they need. 
1. **Fast delivery of Code:** Using containers to test code in isolated mode will reduce the errors on the Dev or LAB env, providing safe code to the CI/CD process. 
---

![bg](https://user-images.githubusercontent.com/15751283/131571995-d0e1d8b1-f899-43d8-a885-a42c05232793.png)

![Height:800px](https://user-images.githubusercontent.com/15751283/131584450-c369aa6a-59dc-494d-b9d3-2ac20bdbebb0.png)

---

![bg](https://user-images.githubusercontent.com/15751283/131571995-d0e1d8b1-f899-43d8-a885-a42c05232793.png)

# Ingredients

---

![bg](https://user-images.githubusercontent.com/15751283/131571995-d0e1d8b1-f899-43d8-a885-a42c05232793.png)

1. **Docker Desktop Application.**
1. **Azure Data Studio or Visual Studio Code.**
1. **Scripting Tool like PowerShell or Programming Language like Python.**
1. **Docker File (Not 100% Required).**
1. **Putty or SSH Tool can be useful to debug the Linux OS.**

---

![bg](https://user-images.githubusercontent.com/15751283/131571995-d0e1d8b1-f899-43d8-a885-a42c05232793.png)


# Docker Main Commands

---

![bg](https://user-images.githubusercontent.com/15751283/131571995-d0e1d8b1-f899-43d8-a885-a42c05232793.png)


```powershell-interactive
docker pull mcr.microsoft.com/mssql/server:2019-latest
```
```powershell-interactive
docker run -e 'ACCEPT_EULA=Y' -e 'SA_PASSWORD=Pass' -p 11433:1433 --name Name -h Name `
-d mcr.microsoft.com/mssql/server:2019-latest
```
```powershell-interactive
# Check docker images
docker ps -a
```
```powershell-interactive
docker exec -it <Container ID> /opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P "<Passw0rd>" `
-Q "SELECT @@VERSION"
```
```powershell-interactive
# Start a Docker container.
docker start <docker id or name>
docker run <docker id or name>
```
```powershell-interactive
# Stop and unload a docker container
docker stop <docker id or name>
docker rm <docker id or name>
```
---

![bg](https://user-images.githubusercontent.com/15751283/131571995-d0e1d8b1-f899-43d8-a885-a42c05232793.png)

# Demo

---

## Biography

[Microsoft SQL Server Container](https://docs.microsoft.com/en-us/sql/linux/sql-server-linux-docker-container-deployment?view=sql-server-ver15&pivots=cs1-powershell)
[Microsoft - Quickstart SQL Server Container](https://docs.microsoft.com/en-us/sql/linux/quickstart-install-connect-docker?view=sql-server-ver15&pivots=cs1-powershell)
[Docker Containers](https://hub.docker.com/)
[Docker Documentation](https://docs.docker.com/docker-hub/)