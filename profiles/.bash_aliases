
export ANT_OPTS='-Xms768m -Xmx1024m -XX:PermSize=256m -XX:MaxPermSize=256m'

## AN added /usr/local/lib to path
export PATH=$PATH:$LD_LIBRARY_PATH:/data/apps/scala/bin:/data/apps/node/bin/:/data/apps/maven/bin/:/usr/local/go/bin

alias gsync='git checkout master && git pull origin master && git rebase master work && git checkout master && git merge work && git push origin master && git checkout work'

alias gesync='git checkout master && git pull origin master && git rebase master work && git checkout master && git merge work && git push origin master:refs/for/master && git checkout work'

alias Grep=grep
alias vi=vim
PS1='$PWD $ '

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

# ffmpeg -ac 1 -f x11grab -s wxga -r 50 -i :0.0 -sameq test.mpg
# magic with awk print from substring cat p2.txt |awk '{print substr($0,index($0, "UserGroup [id=7"))}' |grep -v "perspective update"
alias jd-gui="/data/apps/jd-gui/jd-gui"

alias myjad='/data/apps/jad/jad -sjava -r -d//data/experiment/decompiled -lnc'

ulimit -c unlimited
## AN useful way to make notes about things
note(){
    tgt_file="/data/personal/notes.txt"
    file="/data/personal/tmp_notes.txt"
    tmp_file="/data/personal/temp_note.txt"
    echo `date`>>$file
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
	ifconfig |grep -A 1 $@ |tail -1 |awk '{print substr($2,6)}'
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


# The next line updates PATH for the Google Cloud SDK.
source '/data/apps/wip/tmp/google-cloud-sdk/path.bash.inc'

# The next line enables shell command completion for gcloud.
source '/data/apps/wip/tmp/google-cloud-sdk/completion.bash.inc'

export GOPATH=/data/work/others/gocode

awsdocker(){
aws_login=$(aws ecr get-login --no-include-email --region ap-south-1)
$aws_login
}
