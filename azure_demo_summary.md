# Azure AI Search + OpenAI Demo: End-to-End Summary

## Data Flow
1. **Document Upload** → Azure Blob Storage  
2. **Indexing** → Azure Cognitive Search (semantic + vector)  
3. **User Query** → Front‑End App (Azure App Service or Container Apps; optional Azure Front Door/Application Gateway)  
4. **Retrieval** → Azure Function calls Cognitive Search API  
5. **Generation** → Azure OpenAI Service via managed identity  
6. **History & Cache** → Azure Cosmos DB (or Azure SQL) + Azure Cache for Redis (optional)  
7. **Presentation** → Web UI renders answers, citations, and chat history  
8. **Monitoring** → Azure Application Insights + Azure Monitor alerts

## Usage
- Ingest custom documents (PDF, Word, images) and deploy the reference app.  
- Supports both multi-turn conversational chat and single-turn Q&A modes.  
- Live UI controls allow tuning of retrieval parameters (e.g., top K passages) and generation settings (e.g., temperature, max tokens).  
- Secure interactions using Azure AD managed identities and RBAC for service-to-service calls.  
- Deploy locally with Azure Developer CLI (`azd up`) or in cloud with GitHub Codespaces/Dev Containers.

## Required Azure Services
- **Storage**: Azure Blob Storage  
- **Search**: Azure Cognitive Search  
- **Compute**: Azure App Service or Azure Container Apps  
- **Functions**: Azure Functions (API endpoints)  
- **AI**: Azure OpenAI Service  
- **Database**: Azure Cosmos DB or Azure SQL  
- **Cache**: Azure Cache for Redis (optional)  
- **Monitoring**: Azure Application Insights and Azure Monitor  
- **Networking**: Azure Front Door or Azure Application Gateway (optional)

---
*This concise summary fits on a single page and covers the full data flow, typical usage patterns, and all core Azure services required.*