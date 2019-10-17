
data "aws_iam_policy_document" "worker-role-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}
resource "aws_iam_role" "aws-node" {
  name = "${var.cluster_name}-worker-iam-role"
  assume_role_policy = "${data.aws_iam_policy_document.worker-role-policy.json}"
}

resource "aws_iam_role_policy_attachment" "aws-node-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = "${aws_iam_role.aws-node.name}"
}

resource "aws_iam_role_policy_attachment" "aws-node-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = "${aws_iam_role.aws-node.name}"
}

resource "aws_iam_role_policy_attachment" "aws-node-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = "${aws_iam_role.aws-node.name}"
}

resource "aws_iam_role_policy_attachment" "aws-node-AmazonRoute53ReadOnlyAccess" {
 policy_arn = "arn:aws:iam::aws:policy/AmazonRoute53ReadOnlyAccess"
 role       = "${aws_iam_role.aws-node.name}"
}

resource "aws_iam_instance_profile" "aws-node" {
  name = "${var.cluster_name}-worker-iam-instance-profile"
  role = "${aws_iam_role.aws-node.name}"
}
