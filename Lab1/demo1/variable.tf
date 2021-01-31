variable "git_acc" {
    description = "Git Account for clon repo"
  type = object({
      username = "",
      password = ""
  })
  sensitive = true
}

variable "azure_remote_account" {
    description = "Information for use remote to azure"
    default = ""
    type = object({
        username = "",
        password = ""
    })
    sensitive = true
}