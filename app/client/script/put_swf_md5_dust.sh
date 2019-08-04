#! /bin/sh

files="$1/*"
for filepath in ${files}
do
#    echo ${filepath}
    if [ -d "${filepath}" ]
    then
        ./script/put_swf_md5_dust.sh ${filepath}
    else
        extension=${filepath##*.}
        # echo ${extension}
        if [ "${extension}" = "swf" ]
        then
            # D=`dirname $0`
            # abs_dir=`cd $D;pwd`
#            echo "${filepath} = swf file."
            GET_STRING=`ruby ./script/get_md5_str.rb ${filepath}`
#            echo ${GET_STRING}
            mv -f ${filepath} ${GET_STRING}
 #       else
#            echo "${filepath} = not swf file."
        fi
        # echo "${filepath} = file."
    fi
done

