# basic makefile for building docker images
#
# shabbycon project
#
# Author: Steven E. Pav
# Created: 2014.05.23
# $Id: Makefile 41752 2014-05-19 16:42:34Z steven $

.PHONY: run cid img

USERNAME 							 = dregistry:5000
BASENAME 							?= shabbycon

ADD_FILES 						 = install.sh

DOCKER 								?= docker
DOCKER_DAEMON_FLAGS 	?= 
DOCKER_RUN_FLAGS 			?= --dns=172.24.14.249 --dns=172.24.14.250 --dns=172.24.14.251 --dns=8.8.8.8 --dns=8.8.4.4
DOCKER_BUILD_FLAGS 		?= --rm

###############################

all: img

img: $(BASENAME).img

$(BASENAME).img : Dockerfile $(ADD_FILES)
	$(DOCKER) $(DOCKER_DAEMON_FLAGS) build \
		$(DOCKER_BUILD_FLAGS) -t $(USERNAME)/$(BASENAME) .
	touch $@

attach : $(BASENAME).attach

%.attach : %.img
	$(DOCKER) $(DOCKER_DAEMON_FLAGS) run \
		$(DOCKER_RUN_FLAGS) --rm -i -t \
		-v /etc/localtime:/etc/localtime:ro \
		--entrypoint=/bin/bash $(USERNAME)/$* "-i"

inspect : $(BASENAME).inspect

%.inspect : %.cid
	$(DOCKER) inspect `cat $<`

volumefrom : $(BASENAME).cid
	$(DOCKER) $(DOCKER_DAEMON_FLAGS) run \
		$(DOCKER_RUN_FLAGS) --rm -i -t \
		--volumes-from=`cat $<` \
		--entrypoint=/bin/bash $(USERNAME)/$(BASENAME) "-i"

push : $(BASENAME).push

%.push : %.img
	$(DOCKER) push $(USERNAME)/$*

run : cid

cid : $(BASENAME).cid

nocid : $(BASENAME).nocid

%.cid : %.img
	$(DOCKER) $(DOCKER_DAEMON_FLAGS) run $(DOCKER_RUN_FLAGS) -t \
		-v /etc/localtime:/etc/localtime:ro \
		-v /tmp/docker_msf:/tmp/msf:rw \
		-i --rm --cidfile=$@ --name=$* \
		$(USERNAME)/$*
	$(DOCKER) ps | grep -e "$(USERNAME)/$*"

%.recid : %.cid
	[[ -n $$($(DOCKER) top $$(cat $<) 2>/dev/null) ]] || $(DOCKER) restart $$(cat $<)

%.nocid : %.img
	$(DOCKER) $(DOCKER_DAEMON_FLAGS) run $(DOCKER_RUN_FLAGS) -t \
		-v /etc/localtime:/etc/localtime:ro \
		-v /tmp/docker_msf:/tmp/msf:rw \
		-i --rm --name=$* \
		$(USERNAME)/$*
	$(DOCKER) ps | grep -e "$(USERNAME)/$*"

test : $(BASENAME).test

%.test : %.cid
	-sudo $(DOCKER) cp `cat $<`:/tmp/rrdcollect/mtm_cse.rrd .
	-rrdtool last ./mtm_cse.rrd && date +%s
	-sudo $(DOCKER) cp `cat $<`:/tmp/csf_perf.csv .

stop : $(BASENAME).stop 

%.stop :
	$(DOCKER) ps --no-trunc | grep $* | awk '{print $$1}' | xargs $(DOCKER) stop

rm : $(BASENAME).rm

%.rm : %.cid
	$(DOCKER) stop `cat $<`
	$(DOCKER) rm `cat $<`
	rm $<

# load/save
%_con.tgz : %.cid
	docker export `cat $<` | gzip > $@

%_img.tgz : %.img
	docker save $(USERNAME)/$* | gzip > $@

%.gz : %
	cat $< | gzip > $@

suggestions :
	@echo make img
	@echo make cid
	@echo make run
	@echo sleep `jot -r 1 2 57` && git commit -a -m "working on stuff" && git push origin master

clean :
	-rm *.img
	-rm *.cid

realclean: clean 

#for vim modeline: (do not edit)
# vim:ts=2:sw=2:tw=79:fdm=marker:fmr=FOLDUP,UNFOLD:cms=#%s:tags=tags;:syn=make:ft=make:ai:si:cin:nu:fo=croql:cino=p0t0c5(0:
