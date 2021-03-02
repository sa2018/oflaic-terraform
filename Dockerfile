FROM alpine:3.12

ENV TERRAFORM_VERSION 0.13.6
ENV TERRAFORM_DOCS_VERSION 0.10.1
ENV TFSEC_VERSION 0.37.3
ENV TFLINT_AWS_RULESET 0.2.1

ENV WORKSPACE_VERSION 1.0.0

# Tools
RUN apk --update add jq bash curl git make unzip sudo py-pip py-lxml graphviz openssl git less openssh  && \
    rm -rf /var/lib/apt/lists/* && \
    rm /var/cache/apk/*

# Terraform Binary
RUN cd /usr/local/bin && \
    curl https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip -o terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip

# AWS Cli and Terraform Compliance
RUN pip install awscli terraform-compliance

# aws iam authenticator for eksctl
RUN curl --silent -Lo /usr/local/bin/aws-iam-authenticator https://amazon-eks.s3.us-west-2.amazonaws.com/1.18.9/2020-11-02/bin/linux/amd64/aws-iam-authenticator && \
     chmod +x /usr/local/bin/aws-iam-authenticator

# terraform-docs
RUN curl -Lo /usr/local/bin/terraform-docs https://github.com/terraform-docs/terraform-docs/releases/download/v${TERRAFORM_DOCS_VERSION}/terraform-docs-v${TERRAFORM_DOCS_VERSION}-linux-amd64 && \
    chmod +x /usr/local/bin/terraform-docs

# tflint
RUN curl https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash

# tflint aws plugin
RUN mkdir -p ~/.tflint.d/plugins/ && cd  ~/.tflint.d/plugins/ && \
    curl -L https://github.com/terraform-linters/tflint-ruleset-aws/releases/download/v${TFLINT_AWS_RULESET}/tflint-ruleset-aws_linux_amd64.zip -o tflint-ruleset-aws_linux_amd64.zip && \
    unzip tflint-ruleset-aws_linux_amd64.zip && \
    rm tflint-ruleset-aws_linux_amd64.zip

# tfsec
RUN curl -Lo /usr/local/bin/tfsec https://github.com/tfsec/tfsec/releases/download/v${TFSEC_VERSION}/tfsec-linux-amd64  && \
    chmod +x /usr/local/bin/tfsec

# Change Bash Prompt
RUN /bin/bash -c "echo \"PS1='\[\033[01;31m\]\u@terraform-workspace-${WORKSPACE_VERSION}\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\] \$ '\" >> /root/.bashrc "

# Add bin/ to path
ENV PATH "/opt/workspace/bin:${PATH}"

# Create workspace directory
RUN mkdir /opt/workspace

WORKDIR /opt/workspace

CMD ["/bin/bash"]
