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

variable "RGNameforAutomation" {
  default = ""
}

variable "NameforAutomation" {
  default = ""
}

variable "DSCConfigurations" {
  default = ["RSATFeature","ADRole","WebServerRole"]
}

variable "tags" {
    type = "map"
    default = {
        environment = "training"
        source      = "citadel"
    }
}
