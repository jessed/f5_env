#! /bin/bash


if [[ -z $1 || -z $2 ]]; then
  echo "SYNTAX: $0 {Engagement ID} {customer name} [d|D]"
  exit 1
else
  id=$1
  name=$2
fi

if [[ -n $3 && "(D|d)" =~ $3 ]]; then
  DEBUG=1
  echo "DEBUG mode"
else
  unset DEBUG
fi

match="^bs"
if [[ $id =~ $match ]]; then
  dir="itc/current/${id}-${name}"
  linkname=$(echo $id | sed -e 's/bs//')
else
  dir="itc/current/bs${id}-${name}"
  linkname=$id
fi

if [[ $DEBUG ]]; then
  echo "(DEBUG) mkdir $dir"
  echo "(DEBUG) ln -s $dir ${linkname}"
  echo "(DEBUG) mkdir ${dir}/{tests,results,diagrams,customer,config}"
  echo "(DEBUG) cp itc/current/engagement_notes_template.txt ${dir}/engagement_notes.txt"
  echo "(DEBUG) cp itc/current/Performance_Report_Template.pptx ${dir}/Performance_Report.pptx"
else
  cd $HOME
  mkdir $dir
  ln -s $dir ${linkname}
  mkdir ${dir}/{tests,results,diagrams,customer,config}
  cp itc/current/engagement_notes_template.txt ${dir}/engagement_notes.txt
  cp itc/current/Performance_Report_Template.pptx ${dir}/Performance_Report.pptx
fi

