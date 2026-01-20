"""
Constants for the plugin manifest
"""

ARTIFACT_NAME = "ExamplePlugin"
VERSION = "0.0.0-SNAPSHOT"
GROUP = "com.example"

CONFIG = {
    "Version": VERSION,
    "Name": ARTIFACT_NAME,
    "Group": GROUP,
    "Main": GROUP + ".exampleplugin.ExamplePlugin",
    "IncludesAssetPack": True,
    "Authors": [
        {
            "Name": "Farakov Engineering",
            "Email": "contact@farakovengineering.com",
            "Url": "https://farakovengineering.com",
        },
    ],
}
