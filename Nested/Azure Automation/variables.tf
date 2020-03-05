variable "rg" {
    default = "terraform-lab2"
}

variable "Location" {
    default = ""
}

variable "NameforAutomationAcc" {
  default = ""
}

variable "RGNameforAutomationAcc" {
  default = ""
}

variable "tags" {
    type = "map"
    default = {
        environment = "training"
        source      = "citadel"
    }
}