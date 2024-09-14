
export ANT_OPTS='-Xms768m -Xmx1024m -XX:PermSize=256m -XX:MaxPermSize=256m'

## AN added /usr/local/lib to path
export PATH=$PATH:$LD_LIBRARY_PATH:/data/apps/scala/bin:/data/apps/node/bin/:/data/apps/maven/bin/:/usr/local/go/bin:/home/apurba/.local/bin

alias gsync='git checkout main && git pull origin main && git rebase main work && git checkout main && git merge work && git push origin main && git checkout work'

alias gesync='git checkout main && git pull origin main && git rebase main work && git checkout main && git merge work && git push origin main:refs/for/main && git checkout work'


export data_dir=/data/

alias Grep=grep
alias vi=vim
PS1='\[\e[32m\]\u@\h \[\e[34m\]\w\[\e[0m\]\$ '

alias explorer=nautilus

export JAVA_HOME=/usr/lib/jvm/java/
export PATH=$PATH:$JAVA_HOME/bin
export JRE_HOME=$JAVA_HOME/jre
export PATH=$PATH:/data/apps/eclipse/
export tomcat_home=/data/apps/apache-tomcat

alias myuse='du --max-depth=1 -h'

alias myspace="sudo find . -maxdepth 1 -type d -exec du -h -m --max-depth=0  {} \;|awk '{ if ($1 > 1) print $0 }' |sort -gr"

kbn() {
   a=("$@")
   pl=`ps -ef |grep ${a[0]} |grep ${a[1]}|grep -v grep`
   ptoK=`echo $pl |awk '{print $2}' `
   kill -9 $ptoK
}

gm(){
	args=("$@")
	git status |grep 'modified' | cut -f 2 |awk '{print $2}' |xargs git add
}

set_title(){
	TITLE=("$@") 
	printf "\033]0;$TITLE\007"
}

hit_svr(){
    url_path="$1"
    shift
    json_data="$1"
    curl -X POST "localhost:4000/$url_path" -H "Content-Type: application/json" -d "$json_data"
}
# ffmpeg -ac 1 -f x11grab -s wxga -r 50 -i :0.0 -sameq test.mpg
# magic with awk print from substring cat p2.txt |awk '{print substr($0,index($0, "UserGroup [id=7"))}' |grep -v "perspective update"
alias jd-gui="/data/apps/jd-gui/jd-gui"

alias myjad='/data/apps/jad/jad -sjava -r -d//data/experiment/decompiled -lnc'

ulimit -c unlimited
ulimit -n 20000

## AN useful way to make notes about things
note(){
    tgt_file="/data/personal/notes.txt"
    file="/data/personal/tmp_notes.txt"
    tmp_file="/data/personal/temp_note.txt"
    printf `date +%D`" -- ">>$file
    echo "$@" >>$file
    echo "" >>$file
    cat $file $tgt_file > $tmp_file && mv $tmp_file $tgt_file
    rm $file
}

findclass() {
	a=("$@")
    echo     "/usr/lib/jvm/java-6-sun-1.6.0.26/bin/java  -classpath /data/host/ubuntu-c/workspace/Utils/bin:. org.apurba.util.ClassFinder ${a[0]} ${a[1]}"
    /usr/lib/jvm/java-6-sun-1.6.0.26/bin/java  -classpath /data/host/ubuntu-c/workspace/Utils/bin:. org.apurba.util.ClassFinder "${a[0]}" "${a[1]}"

}


setupPersonalGit() {
    git config --global user.name "sans-sense"
    git config --global user.email "ap.nath@gmail.com"
}

export my_chroot_dir=/data/work/virtual/dtrace_test

printIp() {
	ifconfig |grep -A 1 $@ |tail -1 |awk '{print $2}'
}

alias tstart='$tomcat_home/bin/catalina.sh jpda start'
alias tstop='$tomcat_home/bin/catalina.sh stop'
alias tlogs='tail -f $tomcat_home/logs/catalina.out'

lInB() {
	a=("$@")
    `${a[0]} > /dev/null 2>&1 &`
}


alias gitlog='git show --pretty="format:" --name-only HEAD'

export MAVEN_OPTS='-Xmx1024m -XX:PermSize=256m -Xdebug -Xnoagent -Djava.compiler=NONE -Xrunjdwp:transport=dt_socket,address=8787,server=y,suspend=n'

disableMavenDebug() {
    export MAVEN_OPTS=''
}

cleanClasses() {
    find . -name "*.class" -exec rm {} \;
}

ff() {
    find . -name "*.java" -exec grep -nH $@ {} \;
}

#AN: 18th April, making zeppelin work with internal spark
#export SPARK_HOME=/data/work/projects/DataEngineering/spark/
alias jps='jps -ml'
export SPARK_MEM=2048m
alias tanalyzer="java -jar /data/apps/analysis/jca456.jar"
alias hanalyzer="java -Xmx1024m -XX:PermSize=256m -jar /data/apps/analysis/ha456.jar"

export  TESSDATA_PREFIX=/usr/share/tesseract-ocr


# export Paths for tesseract and leptonica
#export CPLUS_INCLUDE_PATH=/data/work/ss-git/fun/pic2perfect/sandbox/lept-bin/usr/local/include/
#export C_INCLUDE_PATH=$CPLUS_INCLUDE_PATH
export LD_LIBRARY_PATH=/data/work/ss-git/fun/pic2perfect/sandbox/lept-bin/lib:/data/work/ss-git/fun/pic2perfect/sandbox/lept-bin/usr/local/lib:$LD_LIBRARY_PATH
#export LIBRARY_PATH=/data/work/ss-git/fun/pic2perfect/sandbox/lept-bin/usr/local/lib

alias myrefine="cd /data/work/others/OpenRefine/ && refine -i 0.0.0.0 &"

record() {
    base_path="/data/work/wip/recordings"
    if [ -z "$1" ]
    then
        now=$(date +"%m_%d_%Y")
        file_name="$base_path/recording_$now.mp4"
    else
        file_name="$base_path/$1"
    fi

    vlc \
        screen:// --one-instance \
        -I dummy --extraintf rc --rc-host localhost:10082 \
        --screen-follow-mouse \
        --no-video :screen-fps=15 :screen-caching=300 \
        --sout "#transcode{vcodec=h264,vb=800,fps=5,scale=1,acodec=none}:duplicate{dst=std{access=file,mux=mp4,dst=$file_name}}"
   
}

gsettings set org.gnome.desktop.wm.keybindings close "['<Super>q']"

alias space="df -kH |grep /dev/sda4"

#AN: read numbers in millions
export LC_ALL="en_US.UTF-8"


awsdocker(){
aws_login=$(aws ecr get-login --no-include-email --region ap-south-1)
$aws_login
}


day() {
  date -r $(($1 / 1000))
}

cd /data/work/others

function stitle(){
 if [ -z "$PS1_BACK" ];  # set backup if it is empty
 then
  PS1_BACK="$PS1"
 fi

 TITLE="\[\e]0;$*\a\]"
 PS1="${PS1_BACK}${TITLE}"
}

alias st_nb="cd /data/work/others && jupyter lab"
export PYTHONPATH=$PYTHONPATH:/data/work/zenquant/
