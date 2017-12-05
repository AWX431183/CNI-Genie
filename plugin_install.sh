#!/bin/bash

Flannel_plugin() {
if pgrep flannel
then
echo "flannel already running\n"
else
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/v0.9.1/Documentation/kube-flannel.yml
fi

}

Weave_plugin() {

if pgrep weave 
then
echo "weave already running\n"
else
kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"
fi
}

Romana_plugin() {
if pgrep romana
then
echo "romana already running\n"
else
kubectl apply -f https://raw.githubusercontent.com/romana/romana/master/containerize/specs/romana-kubeadm.yml
fi
}

Calico_plugin() {
if pgrep etcd
then
echo "calico already running\n"
else
kubectl apply -f https://docs.projectcalico.org/v2.6/getting-started/kubernetes/installation/hosted/kubeadm/1.6/calico.yaml
fi
}

Plugins_CNI()
{
Flannel_plugin
sleep 1m
Weave_plugin
sleep 1m
Romana_plugin
sleep 1m
Calico_plugin
sleep 1m
}
options () {
	echo "please provide Valid option"

	echo  "valid options are......."

	echo  "1.-all---to install all plugin only"
	echo  "2.-F ----to install flannel only"
	echo  "3.-W---to install Weave only"
	echo  "4.-C----to install Calico only"
	echo  "5.-R---To install romana only"
}


run () {
	echo $@
        echo $1
        flag=0
        declare -a input=("-all" "-f" "-c" "-r" "-w")
               for i in "${input[@]}"
               do
                       if [ "$i" == "$1" ]
                       then
                          flag=1
                       fi
               done


        if [ $flag -eq 0 ]
        then
        options
        exit 1
        fi



	case $1 in
		"-all" ) Plugins_CNI;;
		" -F" ) Flannel_plugin ;;
		"-W" ) Weave_plugin ;;
		"-R" ) Romana_plugin ;;
		"-C" ) Calico_plugin ;;
		*)
		;;
	esac
}


run $@

