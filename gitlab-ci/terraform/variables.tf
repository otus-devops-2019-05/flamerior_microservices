variable project {
  description = "Project ID"
}

variable region {
  description = "Region"

  # Значение по умолчанию
  default = "europe-west1"
}

variable zone {
  description = "zone"

  # Значение по умолчанию
  default = "europe-west1-b"
}

variable public_key_path {
  # Описание переменной
  description = "Path to the public key used for ssh access"
}

variable private_key_path {
  # Описание переменной
  description = "Path to the private key used for ssh access"
}

variable app_quantity {
  description = "Quantity of app instances"
  default     = 1
}

variable disk_image {
  description = "Disk image"
}

variable "autodeploy" {
  default = "true"
}
variable "source_ranges" {
  type = "list"
  default = ["0.0.0.0/0"]
}
