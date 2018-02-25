FROM norionomura/swift:swift-4.1-branch

WORKDIR /package

COPY . ./

RUN apt-get update
RUN apt-get install -yq libssl-dev
RUN swift package clean
RUN swift build
CMD swift test
