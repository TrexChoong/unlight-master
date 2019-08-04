#! /bin/sh

files="$1/*"
for filepath in ${files}
do
#    echo ${filepath}
    if [ -d "${filepath}" ]
    then
        ./script/pull_swf_md5_dust.sh ${filepath}
    else
        filename=${filepath%.*}
        extension=${filename##*.}
        # echo ${filename}
        # echo ${extension}
        if [ "${extension}" = "swf" ]
        then
            # echo "${filepath} = swf file."
            GET_STRING=`ruby ./script/get_pull_dust.rb ${filepath}`
            mv -f ${filepath} ${GET_STRING}
        # else
        #     echo "${filepath} = not swf file."
        fi
    fi
done

