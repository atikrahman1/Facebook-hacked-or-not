#!/bin/bash

echo "Content-type: text/html"
echo ""
echo '<link href="//maxcdn.bootstrapcdn.com/bootstrap/4.1.1/css/bootstrap.min.css" rel="stylesheet" id="bootstrap-css">'
echo '<script src="//maxcdn.bootstrapcdn.com/bootstrap/4.1.1/js/bootstrap.min.js"></script>'
echo '<script src="//cdnjs.cloudflare.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>'
echo '<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.1.0/css/all.css" integrity="sha384-lKuwvrZot6UHsBSfcMvOkWwlCMgc0TaWr+30HWe3a4ltaBwTZhyTEggF5tJv8tbt" crossorigin="anonymous">'
echo '<div class="container">'
echo '<title>Facebook Hacked or not?</title>'
echo '    <br/>'
echo '	<div class="row justify-content-center">'
echo '                        <div class="col-12 col-md-10 col-lg-8"><h1>Facebook Hacked or not Checker <small class="text-muted">(Bangladesh only)</small></h1>'
echo '							<div class="alert alert-warning" role="alert">
  <p> You can input any of the following information : <br>
  url:      <b>https://www.facebook.com/atik8557</b><br>
  username: <b>atik8557</b><br>
  mobile:   <b>01835698574</b><br>
  email:    <b>atik@gmail.com</b></p>
</div>'
echo '                            <form class="card card-sm" action="" method="GET">'
echo '                                <div class="card-body row no-gutters align-items-center">'
echo '                                    <div class="col-auto">'
echo '                                        <i class="fas fa-search h4 text-body"></i>'
echo '                                    </div>'
echo '                                    <!--end of col-->'
echo '                                    <div class="col">'
echo '                                        <input class="form-control form-control-lg form-control-borderless" name="username" type="search" placeholder="https://facebook.com/abcd or atik@gmail.com or 0183580XXXX">'
echo '                                    </div>'
echo '                                    <!--end of col-->'
echo '                                    <div class="col-auto">'
echo '                                        <button class="btn btn-lg btn-success" type="submit">Search</button>'
echo '                                    </div>'
echo '                                    <!--end of col-->'
echo '                                </div>'
echo '                            </form>'
echo '                        </div><br>'


urldecode() {
    # urldecode <string>

    local url_encoded="${1//+/ }"
    printf '%b' "${url_encoded//%/\\x}"
}


USERNAME=`echo "$QUERY_STRING" | sed -n 's/^.*username=\([^&]*\).*$/\1/p' | sed "s/+/ /g"`

FDUSER=`urldecode $USERNAME`

emailregex="^[a-z0-9!#\$%&'*+/=?^_\`{|}~-]+(\.[a-z0-9!#$%&'*+/=?^_\`{|}~-]+)*@([a-z0-9]([a-z0-9-]*[a-z0-9])?\.)+[a-z0-9]([a-z0-9-]*[a-z0-9])?\$"

if [[ $FDUSER == *"https://www.facebook.com/profile.php?id="* ]]; then
   id=$(echo $FDUSER | sed 's/[^0-9]*//g')
elif [[ $FDUSER == *"https://facebook.com/"* ]]; then
    DUSER=$(echo $FDUSER | sed 's|https://|https://www.|g')
elif [[ $FDUSER == *"http://facebook.com/"* ]]; then
    DUSER=$(echo $FDUSER | sed 's|http://|https://www.|g')
elif [[ $FDUSER == *"https://www.facebook.com/"* ]]; then
    DUSER=$FDUSER
elif [[ $FDUSER =~ ^[0-9]+$ ]]; then
    MOBILE=$FDUSER
elif [[ $FDUSER =~ $emailregex ]]; then
    EMAIL=$FDUSER
else
    DUSER='https://www.facebook.com/'$FDUSER
fi

if [[ $MOBILE ]]; then
	cmd=$(LC_ALL=C fgrep $MOBILE dump.txt)
elif [[ $EMAIL ]]; then
	cmd=$(LC_ALL=C fgrep $EMAIL dump.txt | sed -r "s/^(.{6})(.{4})/\1XXXX/")
elif [[ $id ]]; then
	cmd=$(LC_ALL=C fgrep $id dump.txt | sed -r "s/^(.{6})(.{4})/\1XXXX/")
else
	id=$(curl -s $DUSER | grep -Eo '<meta property="al:android:url" content="fb:\/\/profile\/[0-9]*"' | grep -Eo '[0-9]*')
	if [[ $id != ^[0-9]+$ ]]; then
		id=$(curl -s -d "fburl=$DUSER&check=Lookup" -X POST https://lookup-id.com/ | grep -Eo '<span id="code">(.*?)<\/span>' | sed 's/[^0-9]*//g')
	fi
	cmd=$(LC_ALL=C fgrep $id dump.txt | sed -r "s/^(.{6})(.{4})/\1XXXX/")
fi


if [[ $cmd ]]; then
    echo '<textarea class="form-control" aria-label="With textarea">'${cmd}'</textarea><br><br>'
    echo '<br><div class="alert alert-danger" role="alert"><h3>You have been Hacked!</h3></div><br><br>'
    echo '<div class="alert alert-primary" role="alert"><p>your fbid is :' $id '</p></div>'
elif [ -z "$USERNAME" ]; then
	echo ''
elif [ -z "$id" ] && [ -z $"EMAIL" ] && [ -z $"MOBILE" ]; then
    echo '<textarea class="form-control" aria-label="With textarea">'${USERNAME}'</textarea><div class="alert alert-warning" role="alert"><p>Your input is wrong! Please check again</p></div>'
else
	echo '<textarea class="form-control" aria-label="With textarea">'${DUSER}'</textarea>
	<div class="alert alert-success" role="alert"><h2>You are safe!</h2></div><br><br>'
	echo '<div class="alert alert-primary" role="alert"><p>your fbid is :' $id '</p></div>'
fi
echo '                    </div>'
echo '</div>'
echo ''
