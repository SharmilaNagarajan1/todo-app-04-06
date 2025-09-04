**Terraform-powered Full-Stack Todo App on Azure** - Deployed a React + Node.js Todo application with **MongoDB Atlas**:  
  - Frontend: React on Azure App Service  
  - Backend: Node.js + Express on Azure App Service  
  - Secrets managed via Azure Key Vault  
  - CI/CD via 2 GitHub Actions pipelines: infrastructure provisioning (Terraform) and application deployment  

React-todo-app:

**Frontend (React)**
- Purpose: UI where users add/delete todos.
Runs on: http://localhost:3000
Talks to: Your backend API (port 5050)

**Backend (Node.js + Express)**
- Purpose: Handles API routes (/api/todos, etc.)
Runs on: http://localhost:5050
Talks to: Your MongoDB database
Also talks to: Your frontend, serving data via API routes.

**Database (MongoDB)**
- Purpose: Stores your actual to-do items (in a collection like todos)
Is not the backend itself, but the backend connects to MongoDB to read/write todo data.
You do not access MongoDB directly from frontend — only the backend talks to it.

User (browser) ↔️ Frontend (React, port 3000)
             ↕️ API calls
Backend (Express, port 5050) ↔️ MongoDB (local or cloud DB)
