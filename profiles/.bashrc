ulimit -c unlimited

## AN useful way to make notes about things
note(){
    echo `date`>>/home/apurba/notes.txt
    echo "$@" >>/home/apurba/notes.txt
    echo "" >>/home/apurba/notes.txt

}

kbn() {
   a=("$@")
   pl=`ps -ef |grep ${a[0]} |grep ${a[1]}|grep -v grep`
   ptoK=`echo $pl |awk '{print $2}' `
   kill -9 $ptoK
}

alias Grep=grep
