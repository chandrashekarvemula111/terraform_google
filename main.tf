terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

# Configure the Google Cloud Provider
provider "google" {
  project = "gcbdr-gl-2"  
  region = "us-central1" # For subnets
}
#backend configuration
backend "gcs" {
   bucket = "terraform-secrets-bucket"
   prefix = "terraform/state" # Optional, helps organize state files
   region = "us-central1"
  }
}
# VPC Network
resource "google_compute_network" "main" {
  name                    = "my-vpc"
  auto_create_subnetworks = false # Disable automatic subnet creation
}

# Subnet 1: US East 1
resource "google_compute_subnetwork" "subnet1" {
  name                    = "my-subnet-us-east1"
  ip_cidr_range          = "10.0.0.0/24"
  network                = google_compute_network.main.id
  region                 = "us-east1"
  private_ip_google_access = true # Enable private access to Google services
}

# Subnet 2: US West 1
resource "google_compute_subnetwork" "subnet2" {
  name                    = "my-subnet-us-west1"
  ip_cidr_range          = "10.0.1.0/24"
  network                = google_compute_network.main.id
  region                 = "us-west1"
  private_ip_google_access = true
}