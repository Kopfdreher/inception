# Inception

**Summary:** This document is a System Administration related exercise.  
**Version:** 5.4

---

## Introduction

This project aims to broaden your knowledge of system administration by using Docker. You will virtualize several Docker images, creating them in your new personal virtual machine.

---

## General guidelines

- This project needs to be done on a **Virtual Machine**.
- All the files required for the configuration of your project must be placed in a `srcs` folder.
- A **Makefile** is also required and must be located at the **root** of your directory. It must set up your entire application (i.e., it has to build the Docker images using `docker-compose.yml`).
- This subject requires putting into practice concepts that, depending on your background, you may not have learned yet. Therefore, we advise you not to hesitate to read a lot of documentation related to Docker usage, as well as anything else you will find helpful in order to complete this assignment.

---



## Mandatory part

This project consists of setting up a small infrastructure composed of different services under specific rules. The whole project has to be done in a virtual machine. You have to use **docker compose**.

### Core rules

- Each Docker image must have the **same name as its corresponding service**.
- Each service has to run in a **dedicated container**.
- For performance reasons, the containers must be built either from the **penultimate stable version** of Alpine or Debian. The choice is yours.
- You have to write your **own Dockerfiles**, one per service. The Dockerfiles must be called in your `docker-compose.yml` by your Makefile.
- You have to **build the Docker images yourself**. It is forbidden to pull ready-made Docker images, as well as using services such as DockerHub (**Alpine/Debian being excluded** from this rule).
- The **latest** tag is prohibited.
- Your containers have to **restart in case of a crash**.



### Required services and volumes

You have to set up:

- A Docker container that contains **NGINX** with **TLSv1.2 or TLSv1.3 only**.
- A Docker container that contains **WordPress + php-fpm** (it must be installed and configured) only, **without nginx**.
- A Docker container that contains **MariaDB** only, **without nginx**.
- A volume that contains your WordPress **database**.
- A second volume that contains your WordPress **website files**.
- You must use **Docker named volumes** for these two persistent storages. **Bind mounts are not allowed** for these volumes.
- These named volumes must be configured so that their data ends up in `/home/login/data` on the host machine. They remain Docker named volumes, not bind mounts. Replace `login` with your learner’s username.
- A **docker-network** that establishes the connection between your containers.



### PID 1 / process management

A Docker container is not a virtual machine. Thus, it is not recommended to use any hacky patches based on `tail -f` and similar methods when trying to run it. Read about how daemons work and whether it’s a good idea to use them or not.

Your containers must **not** be started with a command running an infinite loop. Thus, this also applies to any command used as entrypoint, or used in entrypoint scripts.

**Prohibited hacky patches:**

- `tail -f`
- `bash`
- `sleep infinity`
- `while true`

Read about **PID 1** and the best practices for writing Dockerfiles.

### Networking

- Using `network: host` or `--link` or `links:` is **forbidden**.
- The `network` line **must be present** in your `docker-compose.yml` file.
- Your **NGINX container must be the only entrypoint** into your infrastructure via **port 443 only**, using the **TLSv1.2 or TLSv1.3** protocol.



### WordPress users

In your WordPress database, there must be **two users**, one of them being the administrator.

The administrator’s username **can’t contain** `admin`/`Admin` or `administrator`/`Administrator` (e.g., `admin`, `administrator`, `Administrator`, `admin-123`, and so forth).

### Domain name

To make things simpler, you have to configure your domain name so it points to your local IP address.

This domain name must be `login.42.fr`. You have to use your own login.

For example, if your login is `wil`, `wil.42.fr` will redirect to the IP address pointing to wil’s website.

**This project:** `sgavrilo.42.fr`

### Secrets and environment variables

- **No password must be present in your Dockerfiles.**
- It is **mandatory** to use environment variables.
- It is **mandatory** to use a `.env` file to store environment variables.
- It is **strongly recommended** that you use **Docker secrets** to store any confidential information.
- Any credentials, API keys, or passwords found in your Git repository (outside of properly configured secrets) will result in **project failure**.
- For obvious security reasons, any credentials, API keys, passwords, etc., must be saved locally in various ways/files and **ignored by git**. Publicly stored credentials will lead you directly to a failure of the project.
- You can store your variables (as a domain name) in an environment variable file like `.env`.

---



## Expected directory structure

```
.
├── Makefile
├── secrets/
│   ├── credentials.txt
│   ├── db_password.txt
│   └── db_root_password.txt
└── srcs/
    ├── docker-compose.yml
    ├── .env
    └── requirements/
        ├── bonus/
        ├── mariadb/
        │   ├── conf/
        │   ├── tools/
        │   ├── Dockerfile
        │   └── .dockerignore
        ├── nginx/
        │   ├── conf/
        │   ├── tools/
        │   ├── Dockerfile
        │   └── .dockerignore
        ├── tools/
        └── wordpress/
            ├── conf/
            ├── tools/
            ├── Dockerfile
            └── .dockerignore
```

Example `.env`:

```
DOMAIN_NAME=wil.42.fr
# MYSQL SETUP
MYSQL_USER=XXXXXXXXXXXX
[...]
```

---



## Expected architecture

```
                    ┌─────────────────────────────────────┐
                    │              HOST VM                │
                    │                                     │
  browser ──443──►  │  ┌─────────┐     ┌──────────────┐   │
                    │  │  NGINX  │────►│  WordPress   │   │
                    │  │  TLS    │     │  + php-fpm   │   │
                    │  └─────────┘     └──────┬───────┘   │
                    │                         │           │
                    │                         ▼           │
                    │                  ┌──────────────┐   │
                    │                  │   MariaDB    │   │
                    │                  └──────────────┘   │
                    │                                     │
                    │  volumes:                           │
                    │    /home/login/data/wordpress       │
                    │    /home/login/data/mariadb         │
                    └─────────────────────────────────────┘
```

- NGINX is the only public entrypoint (port 443, TLS).
- WordPress + php-fpm talks to MariaDB on the internal Docker network.
- Two named volumes persist DB data and WordPress files under `/home/login/data`.

---



## README requirements

A `README.md` file must be provided at the **root** of your Git repository. Its purpose is to allow anyone unfamiliar with the project (peers, staff, recruiters, etc.) to quickly understand what the project is about, how to run it, and where to find more information on the topic.

The README.md **must include at least**:

1. The very first line must be italicized and read:
  *This project has been created as part of the 42 curriculum by login1[, login2[, login3[...]]].*
2. A **Description** section that clearly presents the project, including its goal and a brief overview.
3. An **Instructions** section containing any relevant information about compilation, installation, and/or execution.
4. A **Resources** section listing classic references related to the topic (documentation, articles, tutorials, etc.), as well as a description of how AI was used — specifying for which tasks and which parts of the project.
5. Additional sections may be required depending on the project. Any required additions will be explicitly listed below.
6. A **Project description** section must also explain the use of Docker and the sources included in the project. It must indicate the main design choices, as well as a comparison between:
  - Virtual Machines vs Docker
  - Secrets vs Environment Variables
  - Docker Network vs Host Network
  - Docker Volumes vs Bind Mounts

Your README **must be written in English**.

---



## Prerequisites for validation

In addition to the existing requirements, the following documentation files must be present at the **root** of your repository. They must be written in Markdown format (`.md`).

### `USER_DOC.md` — User documentation

This file must explain, in clear and simple terms, how an end user or administrator can:

- Understand what services are provided by the stack.
- Start and stop the project.
- Access the website and the administration panel.
- Locate and manage credentials.
- Check that the services are running correctly.



### `DEV_DOC.md` — Developer documentation

This file must describe how a developer can:

- Set up the environment from scratch (prerequisites, configuration files, secrets).
- Build and launch the project using the Makefile and Docker Compose.
- Use relevant commands to manage the containers and volumes.
- Identify where the project data is stored and how it persists.

---

## Evaluation sheet (scale)

You should evaluate **1 student** in this team.

### Introduction (evaluator rules)

- Remain polite, courteous, respectful and constructive throughout the evaluation process. The well-being of the community depends on it.
- Identify the possible dysfunctions in the project of the student or group whose work is being evaluated. Take the time to discuss and debate the problems that may have been identified.
- You must consider that there might be some differences in how your peers might have understood the project's instructions and the scope of its functionalities. Always keep an open mind and grade them as honestly as possible. Pedagogy is useful only if peer evaluation is done seriously.

### Guidelines

- Only grade the work submitted in the **Git repository** of the evaluated student or group.
- Double-check that the Git repository belongs to the student or students. Ensure that the project is the expected one. Also, check that `git clone` is used in an **empty directory**.
- Check carefully that no malicious aliases were used to deceive you and make you evaluate something that is not the content of the official repository.
- To avoid any surprises, and if applicable, review together any scripts used to facilitate grading (such as testing or automation scripts).
- If you have not completed the assignment you are going to evaluate, you must read the entire subject before starting the evaluation process.
- Use the available flags to report an empty repository, a non-functioning program, a Norm error, cheating, etc. In these cases, the evaluation process ends, and the final grade is **0**, or **-42** in the case of cheating. However, except in cases of cheating, students are strongly encouraged to review the submitted work together to identify any mistakes that should not be repeated in the future.

**Attachments:** `subject.pdf`

---

### Preliminaries

If cheating is suspected, the evaluation stops here. Use the **Cheat** flag to report this. Make this decision calmly and wisely, and please, use this button with caution.

#### Preliminary tests

- The use of a local `.env` file to store info is allowed, and/or also the use of Docker secrets.
- If any credentials, API keys, or passwords are available in the git repository **and outside of secrets files created during the evaluation**, the evaluation **stops** and the mark is **0**.
- Defense can only happen if the evaluated learner or group is **present**. This way everybody learns by sharing knowledge with each other.
- If no work has been submitted (or wrong files, wrong directory, or wrong filenames), the grade is **0**, and the evaluation process ends.
- For this project, you have to **clone their Git repository on their station**.

**Yes / No**

---

### General instructions

For the entire evaluation process, if you don't know how to check a requirement, or verify anything, the evaluated learner has to help you.

- Ensure that all the files required to configure the application are located inside a `srcs` folder. The `srcs` folder must be located at the **root** of the repository.
- Ensure that a **Makefile** is located at the root of the repository.
- Before starting the evaluation, run this command in the terminal:

```bash
docker stop $(docker ps -qa); docker rm $(docker ps -qa); docker rmi -f $(docker images -qa); docker volume rm $(docker volume ls -q); docker network rm $(docker network ls -q) 2>/dev/null
```

- Read the `docker-compose.yml` file. There mustn't be `network: host` in it or `links:`. Otherwise, the evaluation ends now.
- Read the `docker-compose.yml` file. There must be `network(s)` in it. Otherwise, the evaluation ends now.
- Examine the Makefile and all the scripts in which Docker is used. There mustn't be `--link` in any of them. Otherwise, the evaluation ends now.
- Examine the Dockerfiles. If you see `tail -f` or any command run in background in any of them in the **ENTRYPOINT** section, the evaluation ends now. Same thing if `bash` or `sh` are used but not for running a script (e.g, `nginx & bash` or `bash`).
- Examine the Dockerfiles. The containers must be built either from the **penultimate stable version** of Alpine or Debian.
- If the entrypoint is a script (e.g., `ENTRYPOINT ["sh", "my_entrypoint.sh"]`, `ENTRYPOINT ["bash", "my_entrypoint.sh"]`), ensure it runs **no program in background** (e.g, `nginx & bash`).
- Examine all the scripts in the repository. Ensure none of them runs an infinite loop. Prohibited examples: `sleep infinity`, `tail -f /dev/null`, `tail -f /dev/random`.
- Run the Makefile.

**Yes / No**

---

### Mandatory part

This project involves setting up a small infrastructure composed of different services using docker compose. Ensure that all of the following points are correct.

#### Activity overview

The evaluated learner has to explain to you in simple terms:

- How Docker and docker compose work
- The difference between a Docker image used with docker compose and without docker compose
- The benefit of Docker compared to VMs
- The pertinence of the directory structure required for this project (an example is provided in the subject's PDF file)

**Yes / No**

#### README check

- Ensure that a `README.md` file is present at the root of the repository.
- The very first line must follow the required format: *This project has been created as part of the 42 curriculum by \<login...\>* (italicized).
- Check that the README contains at least the required sections: **Description**, **Instructions**, **Resources** (with explanation of how AI was used).
- If any of these elements are missing, the evaluation ends now.

**Yes / No**

#### Documentation check

- Ensure that both `USER_DOC.md` and `DEV_DOC.md` files are present at the root of the repository.
- `USER_DOC.md` must provide basic usage instructions for an end user or administrator (start/stop the stack, access the website and admin panel, manage credentials, basic checks).
- `DEV_DOC.md` must provide developer-oriented instructions (prerequisites, setup, Makefile usage, docker compose commands, data persistence).
- If any of these files are missing or empty, the review ends now.

**Yes / No**

#### Simple setup

- Ensure that NGINX can be accessed by **port 443 only**. Once done, open the page.
- Ensure that a **SSL/TLS certificate** is used.
- Ensure that the WordPress website is properly installed and configured (you shouldn't see the WordPress Installation page). To access it, open `https://login.42.fr` in your browser, where `login` is the login of the evaluated learner.
- You shouldn't be able to access the site via `http://login.42.fr`.
- If something doesn't work as expected, the evaluation process ends now.

**Yes / No**

#### Docker Basics

- Start by checking the Dockerfiles. There must be **one Dockerfile per service**. Ensure that the Dockerfiles are not empty files. If it's not the case or if a Dockerfile is missing, the evaluation process ends now.
- Make sure the evaluated learner has written their **own Dockerfiles** and built their **own Docker images**. It is forbidden to use ready-made ones or to use services such as DockerHub.
- Ensure that every container is built from the **penultimate stable version** of Alpine/Debian. If a Dockerfile does not start with `FROM alpine:X.X.X` or `FROM debian:XXXXX`, or any other local image, the evaluation process ends now.
- The Docker images must have the **same name as their corresponding service**. Otherwise, the evaluation process ends now.
- Ensure that the Makefile has set up all the services via **docker compose**. This means that the containers must have been built using docker compose and that **no crash happened**. Otherwise, the evaluation process ends.

**Yes / No**

#### Docker Network

- Ensure that docker-network is used by checking the `docker-compose.yml` file. Then run `docker network ls` to verify that a network is visible.
- The evaluated learner has to give you a simple explanation of docker-network.
- If any of the above points is not correct, the evaluation process ends now.

**Yes / No**

#### NGINX with SSL/TLS

- Ensure that there is a Dockerfile.
- Using `docker compose ps`, ensure that the container was created (using the flag `-p` is authorized if necessary).
- Try to access the service via HTTP (port 80) and verify that you **cannot** connect.
- Open `https://login.42.fr/` in your browser, where `login` is the login of the evaluated learner. The displayed page must be the configured WordPress website (you shouldn't see the WordPress Installation page).
- The use of a **TLS v1.2 or TLS v1.3** certificate is mandatory and must be demonstrated. The SSL/TLS certificate doesn't have to be recognized. A self-signed certificate warning may appear.
- If any of the above points is not clearly explained and correct, the evaluation process ends now.

**Yes / No**

#### WordPress with php-fpm and its volume

- Ensure that there is a Dockerfile.
- Ensure that there is **no NGINX** in the Dockerfile.
- Using `docker compose ps`, ensure that the container was created (using the flag `-p` is authorized if necessary).
- Ensure that there is a Volume. To do so: run `docker volume ls` then `docker volume inspect <volume name>`. Verify that the result in the standard output contains the path `/home/login/data/`, where `login` is the login of the evaluated learner.
- Ensure that you can add a comment using the available WordPress user.
- Sign in with the administrator account to access the Administration dashboard. The Admin username must **not** include `admin` or `Admin` (e.g., `admin`, `administrator`, `Admin-login`, `admin-123`, and so forth).
- From the Administration dashboard, **edit a page**. Verify on the website that the page has been updated.
- If any of the above points is not correct, the evaluation process ends now.

**Yes / No**

#### MariaDB and its volume

- Ensure that there is a Dockerfile.
- Ensure that there is **no NGINX** in the Dockerfile.
- Using `docker compose ps`, ensure that the container was created (using the flag `-p` is authorized if necessary).
- Ensure that there is a Volume. To do so: run `docker volume ls` then `docker volume inspect <volume name>`. Verify that the result in the standard output contains the path `/home/login/data/`, where `login` is the login of the evaluated learner.
- The evaluated learner must be able to explain how to **login into the database**. Verify that the database is **not empty**.
- If any of the above points is not correct, the evaluation process ends now.

**Yes / No**

#### Persistence!

This part is pretty straightforward.

1. Reboot the virtual machine.
2. Once it has restarted, launch docker compose again.
3. Verify that everything is functional, and that both WordPress and MariaDB are configured.
4. The changes you made previously to the WordPress website should still be here.

If any of the above points is not correct, the evaluation process ends now.

**Yes / No**

#### Configuration modification

During the defense, the reviewer must ask the evaluated person to modify the configuration of one service (for example by changing the port it is using).

- The reviewer is free to choose which service and which new port, as long as the port is available on the system.
- After the change, the evaluated person must **rebuild and restart** the project.
- The service must remain accessible and functional with the new configuration.
- If the modification cannot be performed or the service no longer works, the evaluation ends now.

**Yes / No**

