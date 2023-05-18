function merge_pull_request() {
  pull_request_id=$1
  source_repo=$2
  private_repo=$3
  branch_name=$4

  # Get the fetch URL for the pull request from the GitHub API
  fetch_url=$(curl -s "https://api.github.com/repos/$source_repo/pulls/$pull_request_id" | grep '"patch_url":' | cut -d\" -f4)

  # Switch to the local clone of your private repo
  cd /path/to/your/private/repo

  # Check if the branch exists, if not create it
  git checkout $branch_name || git checkout -b $branch_name

  # Fetch the pull request from the fetch URL
  git fetch $fetch_url && git checkout FETCH_HEAD

  # Merge the fetched pull request into the current branch
  git merge FETCH_HEAD

  # Push the merge to the private repository
  git push origin $branch_name
}

function merge_pull_requests() {
  source_repo=$1
  private_repo=$2

  read -p "Enter the number of the pull request you want to merge: " pull_request_id
  merge_pull_request $pull_request_id $source_repo $private_repo "pull_request_$pull_request_id"
}

# Usage
merge_pull_requests "mckaywrigley/chatbot-ui" "TheSnowGuru/speaq-chatui"
