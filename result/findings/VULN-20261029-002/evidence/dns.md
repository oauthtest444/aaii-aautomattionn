# Evidence — dangling DNS records

Timestamp: 2026-10-29T14:20Z

## Classic ELB target

```
$ dig +short CNAME help-beta-ingress.sptpub.com
a07ff76e120d64a249d5504f3705266f-1179737841.eu-central-1.elb.amazonaws.com.

$ dig +short CNAME api-help-beta-ingress.sptpub.com
a07ff76e120d64a249d5504f3705266f-1179737841.eu-central-1.elb.amazonaws.com.

$ dig +short A help-beta-ingress.sptpub.com
(empty)

$ dig +short a07ff76e120d64a249d5504f3705266f-1179737841.eu-central-1.elb.amazonaws.com
(empty / NXDOMAIN)
```

## Deleted CloudFront targets

```
$ dig +short CNAME api-h-c34e8269-1333.sptpub.com
d1z4jtnwy56ynm.cloudfront.net.

$ dig +short A api-h-c34e8269-1333.sptpub.com
(empty)

$ dig +short A d1z4jtnwy56ynm.cloudfront.net
(empty / NXDOMAIN)

$ dig +short CNAME api-h-d6f5dd34-1091.sptpub.com
d15oykhg75c6eh.cloudfront.net.

$ dig +short A api-h-d6f5dd34-1091.sptpub.com
(empty)

$ dig +short A d15oykhg75c6eh.cloudfront.net
(empty / NXDOMAIN)
```

## Wildcard check

```
$ dig +short A zzq<random>.sptpub.com
(empty / NXDOMAIN)
```

Classic ELB DNS names embed the owning AWS account ID, and CloudFront default
domains are AWS-assigned; neither can be reclaimed by an unrelated AWS account.
