import argparse
from services.s3_manager import S3Manager

def main():
    parser = argparse.ArgumentParser(description="Upload files to S3")
    parser.add_argument('file_path', type=str, help="Path of the file to upload")
    args = parser.parse_args()

    s3_manager = S3Manager()
    if not s3_manager.upload_file(args.file_path):
        print("Failed to upload file.")

if __name__ == "__main__":
    main()
