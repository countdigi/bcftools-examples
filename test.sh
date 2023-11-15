#!/usr/bin/env bash

_data() {
  # translate space from last line of header + data into single tabs
  local in_vcf=$1
  sed '/^#CHROM/,$ s/[[:space:]]\{1,\}/	/g' ${in_vcf}
}

/bin/mkdir -p tmp

# bio-container --quiet bcftools view --no-version <(_data data/01.vcf)

bio-container --quiet bcftools view --no-version <(_data data/01.vcf) \
  | bio-container --quiet bcftools annotate --no-version --remove INFO/AF \
  | bio-container --quiet bcftools plugin fill-tags --no-version -- --tags=AF,AC \
  > tmp/01.vcf

diff tmp/01.vcf <(_data result/01.vcf)
