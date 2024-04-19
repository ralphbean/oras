# Copyright The ORAS Authors.
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM brew.registry.redhat.io/rh-osbs/openshift-golang-builder:rhel_9_1.22 as builder
ARG TARGETPLATFORM
#RUN dnf -y install git make && dnf -y clean all
ENV ORASPKG /oras
ADD . ${ORASPKG}
WORKDIR ${ORASPKG}/oras
RUN go mod vendor
RUN make "build-$(echo $TARGETPLATFORM | tr / -)"
RUN mv ${ORASPKG}/oras/bin/${TARGETPLATFORM}/oras /usr/bin/oras

FROM registry.access.redhat.com/ubi9-micro:latest
COPY --from=builder /usr/bin/oras /usr/bin/oras
RUN mkdir /workspace
WORKDIR /workspace
ENTRYPOINT  ["/usr/bin/oras"]
