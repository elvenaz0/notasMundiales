aws cloudwatch get-metric-statistics \
    --namespace AWS/Route53 \
    --metric-name HealthCheckStatus \
    --dimensions Name=HealthCheckId,Value=ZDQ58BLKKWPI2 \
    --start-time $(date -u -d "-1 day" +"%Y-%m-%dT%H:%M:%SZ") \
    --end-time $(date -u +"%Y-%m-%dT%H:%M:%SZ") \
    --period 300 \
    --statistics Average


------------------------------------

for zone_id in ZDQ58BLKKWPI2 Z3OYSQ9WMEZAKQ Z1JD99PRH03TYB Z3A9IG3HOVRTQM Z3LDBZZTU4PGRJ ZF41A0NTKGTRB Z06216152QIO6FF8K3G0B; do
    echo "=== Hosted Zone ID: $zone_id ===" >> hosted_zones_info.txt
    aws route53 list-resource-record-sets --hosted-zone-id $zone_id \
        --query "ResourceRecordSets[*].{Name:Name, Type:Type, TTL:TTL, Values:ResourceRecords}" --output table >> hosted_zones_info.txt
    echo "" >> hosted_zones_info.txt
done
