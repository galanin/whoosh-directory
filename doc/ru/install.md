Systemd

На удалённом хосте от рута:
```bash
cp /home/deployer/staff_production/current/config/templates/api/systemd/* /etc/systemd/system/
systemctl enable staff_production_api.service staff_production_api.socket
systemctl start staff_production_api.service staff_production_api.socket
```

На удалённом хосте от пользователя deployer:
```bash
pm2 start /home/deployer/staff_production/shared/ecosystem.config.js --env production
```
