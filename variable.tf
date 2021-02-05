variable "git_username" {
  description = "username for clone repo from github"
  default     = ""
  sensitive   = true
}

variable "git_password" {
  description = "password for clone repo from github"
  default     = ""
  sensitive   = true
}

variable "azure_username" {
  description = "Username for remote to azure server"
  default     = ""
  sensitive   = true
}

variable "azure_password" {
  description = "Password for remtoe to azure server"
  default     = ""
  sensitive   = true

}
