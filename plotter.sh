#!/bin/bash
#你的HDD挂载点前缀,如你的硬盘挂在/mnt/farm1,则前缀为farm
prefix="/mnt/farm"
#你的HDD数量，挂载点标号需从1开始标号。如 /mnt/farm1, /mnt/farm2 ....
totalDisk=6
#你的vCPU数量
threads=48
#你的农民公钥
fKey="b09289509b32255d876b67428d7444e80a461395329a002ce127ba7482bc5fc9291b929aee5cf0b4c1f7d917988e9eb4"
#你的矿池公钥
pKey="aef76eece268a5b076aa906b17769529a8831f2431c022a18c0aad92c5a7a9bd25dff436b472b4dd81943500425e351f"
#第一缓存目录，一定要以/结尾
tmp1="/mnt/plot/"
#第二缓存目录，可与第一个相同
tmp2="/mnt/plot/"
count=1
while true
do
   dest="$prefix$count/"
   space=$(df $dest --output=avail | grep -E '^[0-9]')
   space=$(($space / 1024 / 1024))
   if [ $space -gt 109 ]
   then
        echo "Start plotting for farmer_key:$fKey pool_key:$pKey threads:$threads tmp1:$tmp1 tmp2:$tmp2 destination:$dest "
        ./chia_plot --poolkey=$pKey --farmerkey=$fKey --tmpdir=$tmp1 --tmpdir2=$tmp2 --threads=$threads --buckets=8
        echo "Moving plot to $dest ..."
	cp $tmp1*.plot $dest && rm $tmp1*.plot &
   else
	echo "$dest deosn't have enough space, skipping ..."
   fi

   count=$(($count + 1))   
   if [ $count -gt $totalDisk ]
   then
	count=$(($count - $totalDisk))
   fi
   sleep 2
done
