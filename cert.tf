provider "acme" {
  server_url = "https://acme-staging-v02.api.letsencrypt.org/directory"
  #server_url = "https://acme-v02.api.letsencrypt.org/directory"
}

data "aws_route53_zone" "base_domain" {
  name = var.domain
}

resource "tls_private_key" "private_key" {
  algorithm = "RSA"
}

resource "acme_registration" "registration" {
  account_key_pem = tls_private_key.private_key.private_key_pem
  email_address   = "ram.gopinathan@redhat.com" 
}

resource "acme_certificate" "acme" {
    account_key_pem           = acme_registration.registration.account_key_pem
    common_name               = data.aws_route53_zone.base_domain.name
    subject_alternative_names = ["*.${data.aws_route53_zone.base_domain.name}"]

    dns_challenge {
        provider = "route53"

        config = {
            AWS_HOSTED_ZONE_ID = data.aws_route53_zone.base_domain.zone_id
        }
    }
}

# store the generated certs in Amazon Certificate Manager
resource "aws_acm_certificate" "cert" {
    certificate_body = acme_certificate.acme.certificate_pem 
    private_key = acme_certificate.acme.private_key_pem
    certificate_chain = acme_certificate.acme.issuer_pem
}
