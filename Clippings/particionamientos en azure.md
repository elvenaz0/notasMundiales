---
title:
source: "https://learn.microsoft.com/es-es/azure/virtual-machines/linux/expand-disks?tabs=ubuntu"
author:
published:
created: 2025-02-11
description:
tags:
  - "clippings"
---
[Ir al contenido principal](https://learn.microsoft.com/es-es/azure/virtual-machines/linux/?tabs=ubuntu#main)

Este explorador ya no se admite.

Actualice a Microsoft Edge para aprovechar las características y actualizaciones de seguridad más recientes, y disponer de soporte técnico.[Learn](https://learn.microsoft.com/es-es/)

- - [Documentación](https://learn.microsoft.com/es-es/docs/)

Artículos detallados sobre las tecnologías y herramientas de desarrollo de Microsoft
- [Cursos](https://learn.microsoft.com/es-es/training/)

Rutas de aprendizaje personalizadas y cursos
- [Credencial](https://learn.microsoft.com/es-es/credentials/)

Credenciales reconocidas globalmente y aprobadas por el sector
- [Q&A](https://learn.microsoft.com/es-es/answers/)

Preguntas técnicas y respuestas moderadas por Microsoft
- [Ejemplos de código](https://learn.microsoft.com/es-es/samples/)

Biblioteca de ejemplo de código para herramientas y tecnologías de desarrollo de Microsoft
- [Valoraciones](https://learn.microsoft.com/es-es/assessments/)

Guía interactiva, mantenida y recomendaciones
- [Programa](https://learn.microsoft.com/es-es/shows/)

Miles de horas de programación original de expertos de Microsoft

Microsoft Learn para organizaciones

[Aumentar las aptitudes técnicas de su equipo](https://learn.microsoft.com/es-es/training/organizations/)

Acceda a los recursos mantenidos para mejorar las competencias de su equipo y superar las carencias de competencias.

[Iniciar sesión](https://learn.microsoft.com/es-es/azure/virtual-machines/linux/?tabs=ubuntu#)

## Expansión de discos duros virtuales en máquinas virtuales Linux

- Artículo
- 28/10/2024

## En este artículo

1. [Identificación del objeto de disco de datos de Azure en el sistema operativo](https://learn.microsoft.com/es-es/azure/virtual-machines/linux/?tabs=ubuntu#identifyDisk)
2. [Expansión de un disco administrado de Azure](https://learn.microsoft.com/es-es/azure/virtual-machines/linux/?tabs=ubuntu#expand-an-azure-managed-disk)
3. [Expansión de una partición de disco y del sistema de archivos](https://learn.microsoft.com/es-es/azure/virtual-machines/linux/?tabs=ubuntu#expand-a-disk-partition-and-filesystem)
4. [Expansión sin compatibilidad con la SKU de máquina virtual clásica sin tiempo de inactividad](https://learn.microsoft.com/es-es/azure/virtual-machines/linux/?tabs=ubuntu#expanding-without-downtime-classic-vm-sku-support)

**Se aplica a:** ✔️ máquinas virtuales Linux ✔️ conjuntos de escalado flexibles

En este artículo se describe la expansión de discos de sistema operativo y discos de datos para una máquina virtual (VM) de Linux. Tiene la opción de [agregar discos de datos](https://learn.microsoft.com/es-es/azure/virtual-machines/linux/add-disk) para proporcionar espacio de almacenamiento adicional, y también puede expandir un disco de datos existente. Normalmente, el tamaño predeterminado del disco duro virtual del sistema operativo (SO) es de 30 GB en una VM Linux en Azure. En este artículo se describe la expansión de discos del sistema operativo o discos de datos. No se puede expandir el tamaño de los volúmenes seccionados.

Un disco de sistema operativo tiene una capacidad máxima de 4,095 GiB. Sin embargo, muchos sistemas operativos están particionados con un [registro de arranque maestro (MBR)](https://wikipedia.org/wiki/Master_boot_record) de forma predeterminada. MBR limita el tamaño utilizable a 2 TiB. Si necesita más de 2 TiB, considere la posibilidad de conectar discos de datos para el almacenamiento de datos. Si necesita almacenar datos en el disco del sistema operativo y necesita espacio extra, conviértalo a una tabla de particiones GUID (GPT).

Advertencia

Asegúrese siempre de que el sistema de archivos está en buen estado y de que el tipo de tabla de partición de disco (GPT o MBR) admite el nuevo tamaño, y no olvide hacer una copia de seguridad de los datos antes de realizar operaciones de expansión de disco. Para más información, consulte el [inicio rápido de Azure Backup](https://learn.microsoft.com/es-es/azure/backup/quick-backup-vm-portal).## Identificación del objeto de disco de datos de Azure en el sistema operativo

En el caso de expandir un disco de datos cuando hay varios discos de datos presentes en la máquina virtual, puede ser difícil relacionar los LUN de Azure con los dispositivos Linux. Si el disco del sistema operativo necesita expansión, se etiqueta claramente en Azure Portal como disco del sistema operativo.

Empiece por identificar la relación entre el uso del disco, el punto de montaje y el dispositivo, con el comando `df`.

```bash
df -Th
```
```output
Filesystem                Type      Size  Used Avail Use% Mounted on
/dev/sda1                 xfs        97G  1.8G   95G   2% /
<truncated>
/dev/sdd1                 ext4       32G   30G  727M  98% /opt/db/data
/dev/sde1                 ext4       32G   49M   30G   1% /opt/db/log
```

Aquí podemos ver, por ejemplo, que el sistema de archivos `/opt/db/data` está casi lleno, y se encuentra en la partición `/dev/sdd1`. La salida de `df` muestra la ruta de acceso del dispositivo si el disco está montado usando la ruta del dispositivo o el UUID (preferido) en el fstab. Tome nota también de la columna Tipo, que indica el formato del sistema de archivos. El formato es importante más adelante.

Ahora busque el LUN que se correlaciona con `/dev/sdd` examinando el contenido de `/dev/disk/azure/scsi1`. La salida del siguiente comando `ls` muestra que el dispositivo conocido como `/dev/sdd` dentro del sistema operativo Linux se encuentra en LUN1 al mirar en Azure Portal.

```bash
sudo ls -alF /dev/disk/azure/scsi1/
```
```output
total 0
drwxr-xr-x. 2 root root 140 Sep  9 21:54 ./
drwxr-xr-x. 4 root root  80 Sep  9 21:48 ../
lrwxrwxrwx. 1 root root  12 Sep  9 21:48 lun0 -> ../../../sdc
lrwxrwxrwx. 1 root root  12 Sep  9 21:48 lun1 -> ../../../sdd
lrwxrwxrwx. 1 root root  13 Sep  9 21:48 lun1-part1 -> ../../../sdd1
lrwxrwxrwx. 1 root root  12 Sep  9 21:54 lun2 -> ../../../sde
lrwxrwxrwx. 1 root root  13 Sep  9 21:54 lun2-part1 -> ../../../sde1
```## Expansión de un disco administrado de Azure### Expandir sin tiempo de inactividad

Puede expandir los discos administrados sin desasignar la máquina virtual. La configuración de caché del host del disco no cambia si puede expandir o no un disco de datos sin desasignar la máquina virtual.

Esta característica tiene las siguientes limitaciones:

- Solo se admite para discos de datos.
- Si un disco HDD estándar, SSD estándar o SSD prémium es de 4 TiB o menos, desasigne la máquina virtual y desasocie el disco antes de expandirlo a más de 4 TiB. Si uno de esos tipos de disco ya es mayor que 4 TiB, puede expandirlo sin desasignar la máquina virtual ni desasociar el disco. Esto no se aplica discos SSD prémium v2 o Ultra Disks.
- No es compatible con discos compartidos.
- Instale y use una de las opciones siguientes:
- La [CLI de Azure más reciente](https://learn.microsoft.com/es-es/cli/azure/install-azure-cli)
- El [módulo de Azure PowerShell más reciente](https://learn.microsoft.com/es-es/powershell/azure/install-azure-powershell)
- [Azure Portal](https://portal.azure.com/)
- O bien una plantilla de Azure Resource Manager con una versión de API que sea `2021-04-01` o posterior.
- No está disponible en algunas máquinas virtuales clásicas. Use [este script](https://learn.microsoft.com/es-es/azure/virtual-machines/linux/?tabs=ubuntu#expanding-without-downtime-classic-vm-sku-support) para obtener una lista de las SKU de máquina virtual clásica que admiten la expansión sin tiempo de inactividad.### Expansión con disco Ultra y SSD prémium v2

La expansión de discos Ultra y discos SSD prémium v2 tiene las siguientes limitaciones adicionales:

- No se puede ampliar un disco mientras también se está realizando una [copia de datos en segundo plano](https://learn.microsoft.com/es-es/azure/virtual-machines/scripts/create-managed-disk-from-snapshot#performance-impact---background-copy-process) en ese disco, como cuando se está rellenando un disco a partir de [instantáneas](https://learn.microsoft.com/azure/virtual-machines/disks-incremental-snapshots?tabs=azure-cli).
- No se puede expandir una máquina virtual que use [controladores NVMe](https://learn.microsoft.com/es-es/azure/virtual-machines/nvme-overview) para Ultra Disks o discos SSD prémium v2 sin tiempo de inactividad.

Importante

Espere hasta 10 minutos para que se refleje el tamaño correcto en las máquinas virtuales Windows y Linux. En el caso de las máquinas virtuales Linux, debe realizar una [función de repetición de examen de Linux](https://learn.microsoft.com/azure/virtual-machines/linux/expand-disks?tabs=ubuntu#detecting-a-changed-disk-size). Para las máquinas virtuales Windows que no tengan carga de trabajo, debe realizar una [función de repetición de examen de Windows](https://learn.microsoft.com/windows-hardware/drivers/devtest/devcon-rescan). Puede volver a examinar inmediatamente, pero si es dentro de los 10 minutos siguientes, es posible que tenga que volver a examinar de nuevo para mostrar el tamaño correcto.#### Disponibilidad regional

El cambio de tamaño de discos Ultra y discos SSD prémium v2 está disponible actualmente en todas las regiones compatibles con SSD prémium v2 y Ultra.### Expandir el disco administrado de Azure

Asegúrese de que tiene instalada la versión más reciente de la [CLI de Azure](https://learn.microsoft.com/es-es/cli/azure/install-az-cli2) y de que ha iniciado sesión en una cuenta de Azure con [az login](https://learn.microsoft.com/es-es/cli/azure/reference-index#az-login).

En este artículo se requiere una máquina virtual existente en Azure con al menos un disco de datos adjunto y preparado. Si no dispone de una máquina virtual que pueda usar, consulte la sección sobre la [creación y preparación de máquinas virtuales con discos de datos](https://learn.microsoft.com/es-es/azure/virtual-machines/linux/tutorial-manage-disks#create-and-attach-disks).

En los ejemplos siguientes, reemplace los nombres de parámetros de ejemplo, como *myResourceGroup* y *myVM*, con sus propios valores.

Importante

Si el disco cumple los requisitos de [Expandir sin tiempo de inactividad](https://learn.microsoft.com/es-es/azure/virtual-machines/linux/?tabs=ubuntu#expand-without-downtime), puede omitir los pasos 1 y 3.

No se admite la reducción de un disco existente, y puede provocar una pérdida de datos.

Después de expandir los discos, debe expandir el volumen en el sistema operativo para aprovechar el disco más grande.

1. No se pueden realizar operaciones en los discos duros virtuales con la VM en ejecución. Desasigne la máquina virtual con [az vm deallocate](https://learn.microsoft.com/es-es/cli/azure/vm#az-vm-deallocate). En el ejemplo siguiente se desasigna la máquina virtual denominada "*myVM*" en el grupo de recursos *myResourceGroup*:

```azurecli
az vm deallocate --resource-group myResourceGroup --name myVM
```

Nota

Debe desasignar la máquina virtual para expandir el disco duro virtual. Detener la VM con `az vm stop` no libera los recursos de proceso. Para liberar los recursos de proceso, use `az vm deallocate`.
2. Vea la lista de discos administrados de un grupo de recursos con [az disk list](https://learn.microsoft.com/es-es/cli/azure/disk#az-disk-list). En el ejemplo siguiente se muestra una lista de discos administrados del grupo de recursos denominado *myResourceGroup*:

```azurecli
az disk list \
    --resource-group myResourceGroup  \
    --query '[*].{Name:name,size:diskSizeGB,Tier:sku.tier}' \
    --output table
```

Expanda el disco necesario con [az disk update](https://learn.microsoft.com/es-es/cli/azure/disk#az-disk-update). En el ejemplo siguiente se expande el disco administrado llamado *myDataDisk* a *200* GB:

```azurecli
az disk update \
    --resource-group myResourceGroup \
    --name myDataDisk \
    --size-gb 200
```

Nota

Si expande un disco administrado, el tamaño actualizado se redondea al tamaño de disco administrado más próximo. Para obtener una tabla de los tamaños y niveles disponibles para discos administrados, consulte [Comprender la facturación de Azure Disk Storage](https://learn.microsoft.com/es-es/azure/virtual-machines/disks-understand-billing).
3. Inicie la máquina virtual con [az vm start](https://learn.microsoft.com/es-es/cli/azure/vm#az-vm-start). En el ejemplo siguiente se inicia la máquina virtual llamada *myVM* en el grupo de recursos llamado *myResourceGroup*:

```azurecli
az vm start --resource-group myResourceGroup --name myVM
```## Expansión de una partición de disco y del sistema de archivos

Nota

Aunque hay varias herramientas que se pueden usar para realizar el cambio de tamaño de la partición, las herramientas seleccionadas en este documento son las mismas que usan determinados procesos automatizados, como cloud-init. Tal y como está descrito, el uso de la `growpart` herramienta con el `gdisk`paquete proporciona más compatibilidad universal con discos de tabla de particiones GUID (GPT), ya que las versiones anteriores de algunas herramientas como `fdisk` no eran compatibles con los GPT.### Detección de que ha cambiado el tamaño de un disco

Si se expandió un disco de datos sin tiempo de inactividad usando el procedimiento mencionado anteriormente, el tamaño del disco reportado no cambia hasta que se vuelve a escanear el dispositivo, lo que normalmente solo ocurre durante el proceso de arranque. Este examen se puede llamar a petición con el procedimiento siguiente. En este ejemplo, encontramos usando los métodos de este documento que el disco de datos es actualmente `/dev/sda` y se cambió su tamaño de 256 GiB a 512 GiB.

1. Identifique el tamaño reconocido actualmente en la primera línea de salida de `fdisk -l /dev/sda`.

```bash
sudo fdisk -l /dev/sda
```
```output
Disk /dev/sda: 256 GiB, 274877906944 bytes, 536870912 sectors
Disk model: Virtual Disk
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes
Disklabel type: dos
Disk identifier: 0x43d10aad

Device     Boot Start       End   Sectors  Size Id Type
/dev/sda1        2048 536870878 536868831  256G 83 Linux
```
2. Inserte un carácter `1` en el archivo de nuevo examen de este dispositivo. Observe la referencia a sda en el ejemplo. El identificador del disco cambiaría si se redimensionara un dispositivo de disco diferente.

```bash
echo 1 | sudo tee /sys/class/block/sda/device/rescan
```
3. Compruebe que el nuevo tamaño de disco ahora se reconoce

```bash
sudo fdisk -l /dev/sda
```
```output
Disk /dev/sda: 512 GiB, 549755813888 bytes, 1073741824 sectors
Disk model: Virtual Disk
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes
Disklabel type: dos
Disk identifier: 0x43d10aad

Device     Boot Start       End   Sectors  Size Id Type
/dev/sda1        2048 536870878 536868831  256G 83 Linux
```

En el resto de este artículo se usa el disco del sistema operativo para ver los ejemplos del procedimiento para aumentar el tamaño de un volumen en el nivel del sistema operativo. Si el disco expandido es de datos, use las [instrucciones anteriores para identificar el dispositivo de disco de datos](https://learn.microsoft.com/es-es/azure/virtual-machines/linux/?tabs=ubuntu#identifyDisk) y siga esas instrucciones como guía, pero sustituya el dispositivo de disco de datos (por ejemplo `/dev/sda`), los números de partición, los nombres de volumen, los puntos de montaje y los formatos del sistema de archivos, según sea necesario.

Todas las instrucciones del sistema operativo Linux deben verse como genéricas y pueden aplicarse en cualquier distribución, pero generalmente coinciden con las convenciones del anunciante de Marketplace con nombre. Consulte los documentos de Red Hat para conocer los requisitos de los paquetes en cualquier distribución basada en Red Hat o que afirme ser compatible con Red Hat.### Aumento de tamaño del disco de SO

Las instrucciones siguientes se aplican a las distribuciones aprobadas por Linux.

Nota

Antes de continuar, haga una copia de seguridad completa de la VM o realice una instantánea del disco del sistema operativo.

- [Ubuntu](https://learn.microsoft.com/es-es/azure/virtual-machines/linux/?tabs=ubuntu#tabpanel_1_ubuntu)
- [SUSE](https://learn.microsoft.com/es-es/azure/virtual-machines/linux/?tabs=ubuntu#tabpanel_1_suse)
- [Red Hat con LVM](https://learn.microsoft.com/es-es/azure/virtual-machines/linux/?tabs=ubuntu#tabpanel_1_rhellvm)
- [Red Hat sin LVM](https://learn.microsoft.com/es-es/azure/virtual-machines/linux/?tabs=ubuntu#tabpanel_1_rhelraw)

Tanto en Ubuntu 16.x como en las versiones más recientes, la partición raíz del disco del sistema operativo y los sistemas de archivos se expandirán automáticamente para usar todo el espacio contiguo libre en el disco raíz por cloud-init, siempre que haya un poco de espacio libre para la operación de cambio de tamaño. En este caso, la secuencia es simplemente

1. Incremente el tamaño del disco del SO según se detalló anteriormente.
2. Reinicie la máquina virtual y, a continuación, acceda a la máquina virtual mediante la cuenta de usuario **raíz**.
3. Compruebe que el disco de SO ahora presenta un tamaño mayor del sistema de archivos.

Como se muestra en el ejemplo siguiente, se ha cambiado el tamaño del disco de SO del portal a 100 GB. El sistema de archivos **/dev/sda1** montado en **/** muestra ahora 97 GB.

```bash
df -Th
```
```output
Filesystem     Type      Size  Used Avail Use% Mounted on
udev           devtmpfs  314M     0  314M   0% /dev
tmpfs          tmpfs      65M  2.3M   63M   4% /run
/dev/sda1      ext4       97G  1.8G   95G   2% /
tmpfs          tmpfs     324M     0  324M   0% /dev/shm
tmpfs          tmpfs     5.0M     0  5.0M   0% /run/lock
tmpfs          tmpfs     324M     0  324M   0% /sys/fs/cgroup
/dev/sda15     vfat      105M  3.6M  101M   4% /boot/efi
/dev/sdb1      ext4       20G   44M   19G   1% /mnt
tmpfs          tmpfs      65M     0   65M   0% /run/user/1000
user@ubuntu:~#
```

Para aumentar el tamaño del disco de SO en SUSE 12 SP4, SUSE SLES 12 para SAP, SUSE SLES 15 y SUSE SLES 15 para SAP:

1. Siga el procedimiento descrito anteriormente para expandir el disco en la infraestructura de Azure.
2. Acceda a la máquina virtual como usuario **raíz** mediante el comando `sudo` después de iniciar sesión como otro usuario:

```bash
sudo -i
```
3. Use el siguiente comando para instalar el paquete **growpart**, que se usa para cambiar el tamaño de la partición, si no está presente todavía:

```bash
zypper install growpart
```
4. Use el comando `lsblk` para encontrar la partición montada en la raíz del sistema de archivos ( **/** ). En este caso, vemos que la partición 4 del dispositivo **sda** está montada en **/**:

```bash
lsblk
```
```output
NAME   MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda      8:0    0   48G  0 disk
├─sda1   8:1    0    2M  0 part
├─sda2   8:2    0  512M  0 part /boot/efi
├─sda3   8:3    0    1G  0 part /boot
└─sda4   8:4    0 28.5G  0 part /
sdb      8:16   0    4G  0 disk
└─sdb1   8:17   0    4G  0 part /mnt/resource
```
5. Cambie el tamaño de la partición necesaria con el comando `growpart` y el número de partición que se especificó en el paso anterior:

```bash
growpart /dev/sda 4
```
```output
CHANGED: partition=4 start=3151872 old: size=59762655 end=62914527 new: size=97511391 end=100663263
```
6. Vuelva a ejecutar el comando `lsblk` para comprobar si ha aumentado la partición.

El resultado siguiente muestra que se ha cambiado el tamaño de la partición **/dev/sda4** a 46,5 GB:

```bash
lsblk
```
```output
NAME   MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda      8:0    0   48G  0 disk
├─sda1   8:1    0    2M  0 part
├─sda2   8:2    0  512M  0 part /boot/efi
├─sda3   8:3    0    1G  0 part /boot
└─sda4   8:4    0 46.5G  0 part /
sdb      8:16   0    4G  0 disk
└─sdb1   8:17   0    4G  0 part /mnt/resource
```
7. Identifique el tipo de sistema de archivos del disco del sistema operativo mediante el comando `lsblk` con la marca `-f`:

```bash
lsblk -f
```
```output
NAME   FSTYPE LABEL UUID                                 MOUNTPOINT
sda
├─sda1
├─sda2 vfat   EFI   AC67-D22D                            /boot/efi
├─sda3 xfs    BOOT  5731a128-db36-4899-b3d2-eb5ae8126188 /boot
└─sda4 xfs    ROOT  70f83359-c7f2-4409-bba5-37b07534af96 /
sdb
└─sdb1 ext4         8c4ca904-cd93-4939-b240-fb45401e2ec6 /mnt/resource
```
8. Según el tipo del sistema de archivos, use los comandos adecuados para cambiar el tamaño del sistema de archivos.

Use este comando para **xfs**:

```bash
xfs_growfs /
```

Salida de ejemplo:

```output
meta-data=/dev/sda4              isize=512    agcount=4, agsize=1867583 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=0 spinodes=0 rmapbt=0
         =                       reflink=0
data     =                       bsize=4096   blocks=7470331, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
log      =internal               bsize=4096   blocks=3647, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
data blocks changed from 7470331 to 12188923
```

Use este comando para **ext4**:

```bash
resize2fs /dev/sda4
```
9. Compruebe el aumento de tamaño del sistema de archivos para **df -Th** con este comando:

```bash
df -Thl
```

Ejemplo:

```output
Filesystem     Type      Size  Used Avail Use% Mounted on
devtmpfs       devtmpfs  445M  4.0K  445M   1% /dev
tmpfs          tmpfs     458M     0  458M   0% /dev/shm
tmpfs          tmpfs     458M   14M  445M   3% /run
tmpfs          tmpfs     458M     0  458M   0% /sys/fs/cgroup
/dev/sda4      xfs        47G  2.2G   45G   5% /
/dev/sda3      xfs      1014M   86M  929M   9% /boot
/dev/sda2      vfat      512M  1.1M  511M   1% /boot/efi
/dev/sdb1      ext4      3.9G   16M  3.7G   1% /mnt/resource
tmpfs          tmpfs      92M     0   92M   0% /run/user/1000
tmpfs          tmpfs      92M     0   92M   0% /run/user/490
```

En el ejemplo anterior, podemos ver que se ha aumentado el tamaño del sistema de archivos para el disco de SO.

1. Siga el procedimiento descrito anteriormente para expandir el disco en la infraestructura de Azure.
2. Acceda a la máquina virtual como usuario **raíz** mediante el comando `sudo` después de iniciar sesión como otro usuario:

```bash
sudo -i
```
3. Use el comando `lsblk` para determinar cuál volumen lógico (LV) está montado en la raíz del sistema de archivos ( **/** ). En este caso, se ve que **rootvg-rootlv** está montado en **/**. Si un sistema de archivos diferente necesita cambiar el tamaño, sustituya el LV y el punto de montaje en esta sección.

```bash
lsblk -f
```
```output
NAME                  FSTYPE      LABEL   UUID                                   MOUNTPOINT
fd0
sda
├─sda1                vfat                C13D-C339                              /boot/efi
├─sda2                xfs                 8cc4c23c-fa7b-4a4d-bba8-4108b7ac0135   /boot
├─sda3
└─sda4                LVM2_member         zx0Lio-2YsN-ukmz-BvAY-LCKb-kRU0-ReRBzh
   ├─rootvg-tmplv      xfs                 174c3c3a-9e65-409a-af59-5204a5c00550   /tmp
   ├─rootvg-usrlv      xfs                 a48dbaac-75d4-4cf6-a5e6-dcd3ffed9af1   /usr
   ├─rootvg-optlv      xfs                 85fe8660-9acb-48b8-98aa-bf16f14b9587   /opt
   ├─rootvg-homelv     xfs                 b22432b1-c905-492b-a27f-199c1a6497e7   /home
   ├─rootvg-varlv      xfs                 24ad0b4e-1b6b-45e7-9605-8aca02d20d22   /var
   └─rootvg-rootlv     xfs                 4f3e6f40-61bf-4866-a7ae-5c6a94675193   /
```
4. Compruebe si hay espacio disponible en el grupo de volúmenes de LVM que contiene la partición raíz. Si hay espacio disponible, vaya al paso 12.

```bash
vgdisplay rootvg
```
```output
--- Volume group ---
VG Name               rootvg
System ID
Format                lvm2
Metadata Areas        1
Metadata Sequence No  7
VG Access             read/write
VG Status             resizable
MAX LV                0
Cur LV                6
Open LV               6
Max PV                0
Cur PV                1
Act PV                1
VG Size               <63.02 GiB
PE Size               4.00 MiB
Total PE              16132
Alloc PE / Size       6400 / 25.00 GiB
Free  PE / Size       9732 / <38.02 GiB
VG UUID               lPUfnV-3aYT-zDJJ-JaPX-L2d7-n8sL-A9AgJb
```

En este ejemplo, la línea **Free PE / Size** muestra que hay 38,02 GB disponibles en el grupo de volúmenes, porque ya se ha cambiado el tamaño del disco.
5. Instale el paquete **cloud-utils-growpart** para proporcionar el comando **growpart**, que es necesario para aumentar el tamaño del disco del sistema operativo, y el controlador gdisk para los diseños de disco GPT. Este paquete está preinstalado en la mayoría de las imágenes del marketplace.

```bash
dnf install cloud-utils-growpart gdisk
```

En las versiones 7 e inferiores de Red Hat puede usar el comando `yum` en lugar de `dnf`.
6. Determine el disco y la partición que contienen los volúmenes físicos (PV) de LVM del grupo de volúmenes (VG) denominado **rootvg** con el comando **pvscan**. Tome nota del tamaño y el espacio disponible indicados entre corchetes ( **\[** y **\]** ).

```bash
pvscan
```
```output
PV /dev/sda4   VG rootvg          lvm2 [<63.02 GiB / <38.02 GiB free]
```
7. Compruebe el tamaño de la partición mediante `lsblk`.

```bash
lsblk /dev/sda4
```
```output
NAME            MAJ:MIN RM SIZE RO TYPE MOUNTPOINT
sda4              8:4    0  63G  0 part
├─rootvg-tmplv  253:1    0   2G  0 lvm  /tmp
├─rootvg-usrlv  253:2    0  10G  0 lvm  /usr
├─rootvg-optlv  253:3    0   2G  0 lvm  /opt
├─rootvg-homelv 253:4    0   1G  0 lvm  /home
├─rootvg-varlv  253:5    0   8G  0 lvm  /var
└─rootvg-rootlv 253:6    0   2G  0 lvm  /
```
8. Expanda la partición que contiene este volumen físico mediante *growpart*, el nombre de dispositivo y el número de partición. Con ello, se expande la partición especificada para usar todo el espacio disponible contiguo en el dispositivo.

```bash
growpart /dev/sda 4
```
```output
CHANGED: partition=4 start=2054144 old: size=132161536 end=134215680 new: size=199272414 end=201326558
```
9. Compruebe de nuevo que se ha cambiado el tamaño de la partición al esperado con el comando `lsblk`. Observe que, en el ejemplo, **sda4** ha pasado de 63G a 95G.

```bash
lsblk /dev/sda4
```
```output
NAME            MAJ:MIN RM SIZE RO TYPE MOUNTPOINT
sda4              8:4    0  95G  0 part
├─rootvg-tmplv  253:1    0   2G  0 lvm  /tmp
├─rootvg-usrlv  253:2    0  10G  0 lvm  /usr
├─rootvg-optlv  253:3    0   2G  0 lvm  /opt
├─rootvg-homelv 253:4    0   1G  0 lvm  /home
├─rootvg-varlv  253:5    0   8G  0 lvm  /var
└─rootvg-rootlv 253:6    0   2G  0 lvm  /
```
10. Expanda el volumen físico para usar el resto de la partición recién expandida.

```bash
pvresize /dev/sda4
```
```output
Physical volume "/dev/sda4" changed
1 physical volume(s) resized or updated / 0 physical volume(s) not resized
```
11. Compruebe que el nuevo tamaño del volumen físico es el esperado; para ello, compare los valores originales **\[size / free\]** .

```bash
pvscan
```
```output
PV /dev/sda4   VG rootvg          lvm2 [<95.02 GiB / <70.02 GiB free]
```
12. Expanda el volumen lógico en la cantidad necesaria, que no necesariamente tiene que ser todo el espacio disponible en el grupo de volúmenes. En el ejemplo siguiente, se cambia el tamaño de **/dev/mapper/rootvg-rootlv** de 2 GB a 12 GB (un aumento de 10 GB) mediante el siguiente comando. Este comando también cambia el tamaño del sistema de archivos en el LV.

```bash
lvresize -r -L +10G /dev/mapper/rootvg-rootlv
```

Ejemplo:

```output
Size of logical volume rootvg/rootlv changed from 2.00 GiB (512 extents) to 12.00 GiB (3072 extents).
Logical volume rootvg/rootlv successfully resized.
meta-data=/dev/mapper/rootvg-rootlv isize=512    agcount=4, agsize=131072 blks
         =                       sectsz=4096  attr=2, projid32bit=1
         =                       crc=1        finobt=0 spinodes=0
data     =                       bsize=4096   blocks=524288, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
log      =internal               bsize=4096   blocks=2560, version=2
         =                       sectsz=4096  sunit=1 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
data blocks changed from 524288 to 3145728
```
13. El comando `lvresize` llama automáticamente al comando de cambio tamaño adecuado para el sistema de archivos del volumen lógico. Compruebe si **/dev/mapper/rootvg-rootlv**, que está montado en **/**, tiene un mayor tamaño del sistema de archivos, para lo que debe usar el comando `df -Th`:

Salida de ejemplo:

```bash
df -Th /
```
```output
Filesystem                Type  Size  Used Avail Use% Mounted on
/dev/mapper/rootvg-rootlv xfs    12G   71M   12G   1% /
```

Nota

Para usar el mismo procedimiento para cambiar el tamaño de cualquier otro volumen lógico, cambie el nombre **lv** en el paso **12**.

1. Siga el procedimiento descrito anteriormente para expandir el disco en la infraestructura de Azure.
2. Acceda a la máquina virtual como usuario **raíz** mediante el comando `sudo` después de iniciar sesión como otro usuario:

```bash
sudo -i
```
3. Instale el paquete **cloud-utils-growpart** para proporcionar el comando **growpart**, que es necesario para aumentar el tamaño del disco del sistema operativo, y el controlador gdisk para los diseños de disco GPT. Este paquete está preinstalado en la mayoría de las imágenes del marketplace.

```bash
dnf install cloud-utils-growpart gdisk
```

En las versiones 7 e inferiores de Red Hat puede usar el comando `yum` en lugar de `dnf`.
4. Use el comando **lsblk -f** para comprobar la partición y el tipo de sistema de archivos que contiene la partición raíz (**/**).

```bash
lsblk -f
```
```output
NAME    FSTYPE LABEL UUID                                 MOUNTPOINT
sda
├─sda1  xfs          2a7bb59d-6a71-4841-a3c6-cba23413a5d2 /boot
├─sda2  xfs          148be922-e3ec-43b5-8705-69786b522b05 /
├─sda14
└─sda15 vfat         788D-DC65                            /boot/efi
sdb
└─sdb1  ext4         923f51ff-acbd-4b91-b01b-c56140920098 /mnt/resource
```
5. Para la comprobación, empiece por mostrar la tabla de particiones del disco sda con **gdisk**. En este ejemplo, vemos un disco de 48,0 GiB con la partición 2 con 29,0 GiB. El disco se amplió de 30 GB a 48 GB en el Azure Portal.

```bash
gdisk -l /dev/sda
```
```output
GPT fdisk (gdisk) version 0.8.10

Partition table scan:
MBR: protective
BSD: not present
APM: not present
GPT: present

Found valid GPT with protective MBR; using GPT.
Disk /dev/sda: 100663296 sectors, 48.0 GiB
Logical sector size: 512 bytes
Disk identifier (GUID): 78CDF84D-9C8E-4B9F-8978-8C496A1BEC83
Partition table holds up to 128 entries
First usable sector is 34, last usable sector is 62914526
Partitions will be aligned on 2048-sector boundaries
Total free space is 6076 sectors (3.0 MiB)

Number  Start (sector)    End (sector)  Size       Code  Name
1         1026048         2050047   500.0 MiB   0700
2         2050048        62912511   29.0 GiB    0700
14            2048           10239   4.0 MiB     EF02
15           10240         1024000   495.0 MiB   EF00  EFI System Partition
```
6. Expanda la partición para la raíz, en este caso sda2, con el comando **growpart**. El uso de este comando expande la partición para usar todo el espacio contiguo del disco.

```bash
growpart /dev/sda 2
```
```output
CHANGED: partition=2 start=2050048 old: size=60862464 end=62912512 new: size=98613214 end=100663262
```
7. Ahora vuelva a imprimir la nueva tabla de particiones con **gdisk**. Observe que la partición 2 tiene ahora un tamaño de 47,0 GiB

```bash
gdisk -l /dev/sda
```
```output
GPT fdisk (gdisk) version 0.8.10

Partition table scan:
MBR: protective
BSD: not present
APM: not present
GPT: present

Found valid GPT with protective MBR; using GPT.
Disk /dev/sda: 100663296 sectors, 48.0 GiB
Logical sector size: 512 bytes
Disk identifier (GUID): 78CDF84D-9C8E-4B9F-8978-8C496A1BEC83
Partition table holds up to 128 entries
First usable sector is 34, last usable sector is 100663262
Partitions will be aligned on 2048-sector boundaries
Total free space is 4062 sectors (2.0 MiB)

Number  Start (sector)    End (sector)  Size       Code  Name
   1         1026048         2050047   500.0 MiB   0700
   2         2050048       100663261   47.0 GiB    0700
14            2048           10239   4.0 MiB     EF02
15           10240         1024000   495.0 MiB   EF00  EFI System Partition
```
8. Expanda el sistema de archivos en la partición con **xfs\_growfs**, que es adecuado para un sistema RedHat estándar generado por el marketplace:

```bash
xfs_growfs /
```
```output
meta-data=/dev/sda2              isize=512    agcount=4, agsize=1901952 blks
         =                       sectsz=4096  attr=2, projid32bit=1
         =                       crc=1        finobt=0 spinodes=0
data     =                       bsize=4096   blocks=7607808, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
log      =internal               bsize=4096   blocks=3714, version=2
         =                       sectsz=4096  sunit=1 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
data blocks changed from 7607808 to 12326651
```
9. Use el comando **df** para comprobar que el nuevo tamaño se vea reflejado.

```bash
df -hl
```
```output
Filesystem      Size  Used Avail Use% Mounted on
devtmpfs        452M     0  452M   0% /dev
tmpfs           464M     0  464M   0% /dev/shm
tmpfs           464M  6.8M  457M   2% /run
tmpfs           464M     0  464M   0% /sys/fs/cgroup
/dev/sda2        48G  2.1G   46G   5% /
/dev/sda1       494M   65M  430M  13% /boot
/dev/sda15      495M   12M  484M   3% /boot/efi
/dev/sdb1       3.9G   16M  3.7G   1% /mnt/resource
tmpfs            93M     0   93M   0% /run/user/1000
```## Expansión sin compatibilidad con la SKU de máquina virtual clásica sin tiempo de inactividad

Si usa una SKU de máquina virtual clásica, es posible que no admita la expansión de discos sin tiempo de inactividad.

Use el siguiente script de PowerShell para determinar con qué SKU de máquina virtual está disponible:

```azurepowershell
Connect-AzAccount
$subscriptionId="yourSubID"
$location="desiredRegion"
Set-AzContext -Subscription $subscriptionId
$vmSizes=Get-AzComputeResourceSku -Location $location | where{$_.ResourceType -eq 'virtualMachines'}

foreach($vmSize in $vmSizes){
    foreach($capability in $vmSize.Capabilities)
    {
       if(($capability.Name -eq "EphemeralOSDiskSupported" -and $capability.Value -eq "True") -or ($capability.Name -eq "PremiumIO" -and $capability.Value -eq "True") -or ($capability.Name -eq "HyperVGenerations" -and $capability.Value -match "V2"))
        {
            $vmSize.Name
       }
   }
}
```

---

## Comentarios

¿Le ha resultado útil esta página?

## Recursos adicionales

---

Cursos

---

Documentación

- [Expansión de discos duros virtuales conectados a una máquina virtual de Windows Azure - Azure Virtual Machines](https://learn.microsoft.com/es-es/azure/virtual-machines/windows/expand-disks?source=recommendations)

Expanda el tamaño del disco duro virtual conectado a una máquina virtual con Azure PowerShell en el modelo de implementación de Resource Manager.
- [Conexión de un disco de datos a una máquina virtual Linux - Azure Virtual Machines](https://learn.microsoft.com/es-es/azure/virtual-machines/linux/attach-disk-portal?source=recommendations)

Use el portal para conectar un disco de datos nuevo o existente a una máquina virtual Linux.
- [Conexión de un disco de datos administrado a una máquina virtual de Windows: Azure - Azure Virtual Machines](https://learn.microsoft.com/es-es/azure/virtual-machines/windows/attach-managed-disk-portal?source=recommendations)

Cómo conectar un disco de datos administrado a una máquina virtual Windows en Azure Portal.
- [Agregue un disco de datos a la máquina virtual Linux mediante la CLI de Azure - Azure Virtual Machines](https://learn.microsoft.com/es-es/azure/virtual-machines/linux/add-disk?source=recommendations)

Aprenda a agregar un disco de datos persistente a una máquina virtual de Linux con la CLI de Azure
- [Desconexión de un disco de datos de una máquina virtual Linux: Azure - Azure Virtual Machines](https://learn.microsoft.com/es-es/azure/virtual-machines/linux/detach-disk?source=recommendations)

Información sobre cómo desconectar un disco de datos de una máquina virtual de Azure mediante la CLI de Azure o Azure Portal.
- [Expansión de discos no administrados en Azure - Azure Virtual Machines](https://learn.microsoft.com/es-es/azure/virtual-machines/expand-unmanaged-disks?source=recommendations)

Expanda el tamaño del disco duro virtual no administrado conectado a una máquina virtual con Azure PowerShell en el modelo de implementación de Resource Manager.
- [Asignación de discos de Azure a discos invitados de una máquina virtual Linux - Azure Virtual Machines](https://learn.microsoft.com/es-es/azure/virtual-machines/linux/azure-to-guest-disk-mapping?source=recommendations)

Determinación de los discos de Azure que subyacen a los discos invitados de una máquina virtual Linux.
- [Cómo cambiar el tamaño de los discos cifrados con Azure Disk Encryption - Azure Virtual Machines](https://learn.microsoft.com/es-es/azure/virtual-machines/linux/how-to-resize-encrypted-lvm?source=recommendations)

En este artículo se proporcionan instrucciones para cambiar el tamaño de los discos cifrados de ADE mediante la administración de volúmenes lógicos.

### En este artículo