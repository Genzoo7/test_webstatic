variable "location" {
  description = "Azure region for all resources"
  type        = string
  default     = "East US"
}

variable "project" {
  description = "Project tag value"
  type        = string
  default     = "static-website"
}

variable "resource_prefix" {
  description = "Prefix for resource names"
  type        = string
}

variable "index_html_content" {
  description = "HTML content for index page"
  type        = string
  default     = "<html><body><h1>Hello World!</h1></body></html>"
}

# define in env 
variable "resource_group_name" {
  type = string
}
# define in env 
variable "storage_account_name" {
  type = string
}
