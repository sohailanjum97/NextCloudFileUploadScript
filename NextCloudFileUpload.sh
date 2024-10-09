stage('Upload to Nextcloud') {
            steps {
                container('build-container') {
                    sh '''
                    #!/bin/bash
        
                    # Nextcloud credentials
                    NEXTCLOUD_URL="https://nextcloud.mic.com.tw/remote.php/dav/files/username/foldername/"
                    USERNAME="xxxxxxxxxxxxxxxxxx"
                    PASSWORD="xxxxxxxxxxxxxxxxxxx"
        
                    # Directory containing the files to upload
                    FILES_DIR="/home/jenkins/agent/tmp/deploy/images/intel-ast2600/pfr_images"
        
                    # Full paths to the files to upload
                    FILE_1="$FILES_DIR/OBMC-E7142-r520g6-0.10-1-g52520476-52520476-pfr-full-a.ROM"
                    FILE_2="$FILES_DIR/OBMC-E7142-r520g6-0.10-1-g52520476-52520476-pfr-full-b.ROM"
                    FILE_3="$FILES_DIR/OBMC-E7142-r520g6-0.10-1-g52520476-52520476-pfr-full.ROM"
                    FILE_4="$FILES_DIR/OBMC-E7142-r520g6-0.10-1-g52520476-52520476-pfr-oob.bin"
        
                    # Function to generate MD5 hash and save to a file
                    generate_md5() {
                        local file_path="\$1"
                        local hash_file_path="${file_path}.md5"
        
                        # Calculate MD5 hash and save to file
                        md5sum "$file_path" | awk '{ print \$1 }' > "$hash_file_path"
                        if [ $? -eq 0 ]; then
                            echo "MD5 hash generated for: $(basename "$file_path")"
                        else
                            echo "Failed to generate MD5 hash for: $(basename "$file_path")"
                        fi
                    }
        
                    # Function to upload a file
                    upload_file() {
                        local file_path="\$1"
                        local file_name=$(basename "$file_path")
        
                        # Upload the file (replaces if the file already exists)
                        curl -u "$USERNAME:$PASSWORD" -T "$file_path" "$NEXTCLOUD_URL$file_name" --progress-bar
                        if [ $? -eq 0 ]; then
                            echo "Successfully uploaded: $file_name"
                        else
                            echo "Failed to upload: $file_name"
                        fi
                    }
        
                    # Generate MD5 hashes for each file
                    generate_md5 "$FILE_1"
                    generate_md5 "$FILE_2"
                    generate_md5 "$FILE_3"
                    generate_md5 "$FILE_4"
        
                    # Upload each file and its MD5 hash
                    upload_file "$FILE_1"
                    upload_file "${FILE_1}.md5"
                    upload_file "$FILE_2"
                    upload_file "${FILE_2}.md5"
                    upload_file "$FILE_3"
                    upload_file "${FILE_3}.md5"
                    upload_file "$FILE_4"
                    upload_file "${FILE_4}.md5"
                    '''
                }
            }
        }
