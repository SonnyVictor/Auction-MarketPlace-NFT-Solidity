// SPDX-License-Identifier: MIT
pragma solidity >=0.8.15;

contract EncodeContract {
    string[] private z = [
        '<svg width="32" height="32" viewBox="0 0 32 32" fill="none" xmlns="http://www.w3.org/2000/svg">',
        '<path fill-rule="evenodd" clip-rule="evenodd" d="M12 10H13V12V13H14V15H13V14H12V12V10Z" fill="#FFCC80"/>',
        '<path fill-rule="evenodd" clip-rule="evenodd" d="M13 10H20V11V12V13V14H19V15H14V14V13H15V12V11H13V10ZM19 12V13H17V12V11H19V12Z" fill="#FFE0B2"/>',
        '<path fill-rule="evenodd" clip-rule="evenodd" d="M12 18H10V19V20H12V19V18Z" fill="#FFE0B2"/>',
        '<path fill-rule="evenodd" clip-rule="evenodd" d="M17 25H18V26H19V27H18H17V26V25Z" fill="#FFE0B2"/>',
        '<path fill-rule="evenodd" clip-rule="evenodd" d="M14 25H15V26V27H14H13V26H14V25Z" fill="#FFE0B2"/>',
        '<path fill-rule="evenodd" clip-rule="evenodd" d="M20 18H21H22V19V20H21H20V19V18Z" fill="#FFE0B2"/>',
        '<path fill-rule="evenodd" clip-rule="evenodd" d="M23 18H22V19V20H23V19V18Z" fill="#FFCC80"/>',
        '<path fill-rule="evenodd" clip-rule="evenodd" d="M13 25H12V26H11V27H12H13V26H14V25H13Z" fill="#FFCC80"/>',
        '<path fill-rule="evenodd" clip-rule="evenodd" d="M19 25H18V26H19V27H20H21V26H20V25H19Z" fill="#FFCC80"/>',
        '<path fill-rule="evenodd" clip-rule="evenodd" d="M10 18H9V19V20H10V19V18Z" fill="#FFCC80"/>',
        '<path fill-rule="evenodd" clip-rule="evenodd" d="M15 24H13V25H15V24ZM19 24H17V25H19V24Z" fill="white"/>',
        '<path fill-rule="evenodd" clip-rule="evenodd" d="M12 10H11V11V12H10V13H9V14V15H8V16V17V18V19V20H9V21H10H11H12V22V23V24V25H11V26H10V27V28H11H12H13H14H15H16H17H22V27V26H21V25H20V24V23V22V21H21H22H23V20H24V19V18V17V16V15H23V14V13H22V12H21V11V10H20V11V12V13V14H19V15H13V14H12V13V12V11V10ZM12 14V15H13V16H19V15H20V14H21V13H22V14V16H23V15V17V18V19V20H22H21H20V19V18V17H19V18V19V20H13V19V18V17H12V18V19V20H11H10H9V19V18V17V16H10V15V14V13H11V14H12ZM20 25V26H21V27H17V24V23H16H15V24V25V27H14H13H12H11V26H12V25H13V24V23V22V21H19V22V23V24V25H20Z" fill="black"/>',
        '<path fill-rule="evenodd" clip-rule="evenodd" d="M21 13H22V14V15V16H23V17V18H20V17H19V20H18V19H17V17H18V16H19V15H20V14H21V13ZM15 17V16H17V17H15ZM15 19V17H14V16H13V15H12V14H11V13H10V14V15V16H9V17V18H12V17H13V20H14V19H15ZM15 19V20H17V19H15Z" style="fill:#',
        '<path fill-rule="evenodd" clip-rule="evenodd" d="M14 16H15V17H14V16ZM17 17H16H15V18V19H14V20H15V19H16H17V20H18V19H17V18V17ZM17 17V16H18V17H17Z" style="fill:#',
        '<path d="M13 21H19V24H17V23H16H15V24H13V21Z" style="fill:#',
        '</svg>'
    ];

    string[] private color = ["12AAFF","213147","046664","349905","6CC323","FFCF00","FC9A02","E43614", "CE161F","9C0264", "68186D", "0C1778", "273084"];

    function encodeZFrame() public view returns (bytes memory) {
        bytes memory encoded = abi.encode(z);
        return encoded;
    }

    function encodeColorFrame() public view returns (bytes memory) {
        bytes memory encoded = abi.encode(color);
        return encoded;
    }
 

    function encodeEyes() public pure returns (bytes memory) {
        string[4] memory eyes = [
            '<path fill-rule="evenodd" clip-rule="evenodd" d="M13 11H14H15V12V13H14H13V12V11ZM17 13V12V11H18H19V12V13H18H17Z" fill="white"/><path fill-rule="evenodd" clip-rule="evenodd" d="M14 11H13V12H14V11ZM18 11H17V12H18V11Z" style="fill:#',
            '<path fill-rule="evenodd" clip-rule="evenodd" d="M13 11H14H15V12V13H14H13V12V11ZM17 13V12V11H18H19V12V13H18H17Z" fill="white"/><path fill-rule="evenodd" clip-rule="evenodd" d="M15 11H14V12H15V11ZM19 11H18V12H19V11Z" style="fill:#',
            '<path fill-rule="evenodd" clip-rule="evenodd" d="M13 11H14H15V12V13H14H13V12V11ZM17 13V12V11H18H19V12V13H18H17Z" fill="white"/><path fill-rule="evenodd" clip-rule="evenodd" d="M15 12H14V13H15V12ZM19 12H18V13H19V12Z" style="fill:#',
            '<path fill-rule="evenodd" clip-rule="evenodd" d="M13 11H14H15V12V13H14H13V12V11ZM17 13V12V11H18H19V12V13H18H17Z" fill="white"/><path fill-rule="evenodd" clip-rule="evenodd" d="M14 12H13V13H14V12ZM18 12H17V13H18V12Z" style="fill:#'
            ];
        bytes memory encoded = abi.encode(eyes);
        return encoded;
    }

    function encodeHats() public pure returns (bytes memory) {
        string[3][5] memory hats = [
            ['<path fill-rule="evenodd" clip-rule="evenodd" d="M12 5H20V6V7H12V6V5ZM21 8H11V9H21V8Z" style="fill:#', 
            '<path fill-rule="evenodd" clip-rule="evenodd" d="M12 4L16 3L20 4V5L19 6H13L12 5V4ZM12 5V6L16 7L20 6V5H21V6V7H22V8V9V10H10V9V8V7H11V6V5H12ZM21 8V9H11V8H21Z" style="fill:#',
            'pointed hat'
            ],
            ['<path fill-rule="evenodd" clip-rule="evenodd" d="M12 6H20V7H12V6ZM21 8H11V9H21V8Z" style="fill:#',
            '<path fill-rule="evenodd" clip-rule="evenodd" d="M12 4L16 3L20 4V5V6H12V5V4ZM12 5V6L16 7L20 6V5H21V6V7H24V8L22 9V10H10V9L8 8V7H11V6V5H12ZM21 8V9H11V8H21Z" style="fill:#',
            'Police Hat'
            ],
            ['<path fill-rule="evenodd" clip-rule="evenodd" d="M12 4H13H19H20V5H21V6V7H23V8H22V9V10H10V9V8H9V7H11V6V5H12V4Z" style="fill:#',
            '<path fill-rule="evenodd" clip-rule="evenodd" d="M17 6H15V7H17V6ZM10 9H22V10H10V9Z" style="fill:#',
            'square hat'
            ],
            ['<path fill-rule="evenodd" clip-rule="evenodd" d="M18 6H17H16H15H14H13V7H14H15H16H17H18H19V6H18ZM12 9H13H20V10H13H12V9Z" fill="#FFE0B2"/><path fill-rule="evenodd" clip-rule="evenodd" d="M18 5H19V6H18H17H16H15H14H13V5H14H15H16H17H18ZM12 7V6H13V7H12ZM12 7V8V9V10H11V9V8V7H12ZM20 7H19V6H20V7ZM21 9V8V7H20V8V9V10H21V9Z" fill="black"/><path fill-rule="evenodd" clip-rule="evenodd" d="M13 8H12V9H13H14H15H16H17H18H19H20V8H19H18H17H16H15H14H13Z" style="fill:#',
            '<path fill-rule="evenodd" clip-rule="evenodd" d="M13 7H12V8H13H14H15H16H17H18H19H20V7H19H18H17H16H15H14H13Z" style="fill:#',
            'bald'
            ],
            ['<path fill-rule="evenodd" clip-rule="evenodd" d="M12 5H20V6V7H12V6V5ZM21 8H11V9H21V8Z" style="fill:#',
            '<path fill-rule="evenodd" clip-rule="evenodd" d="M12 4H13H19H20V5H19H13H12V4ZM12 5V6V7H20V6V5H21V6V7H22V8V9V10H10V9V8V7H11V6V5H12ZM21 8V9H11V8H21Z" style="fill:#',
            'pillbox hat'
            ]
        ];
        bytes memory encoded = abi.encode(hats);
        return encoded;
    }

    function encodeAccessory() public pure returns(bytes memory) {
        string[2] memory accessory = ['<path fill-rule="evenodd" clip-rule="evenodd" d="M11 10H12H13H14H15H16H17H18H19H20H21V11H20V12V13V14H19H18H17H16H15H14H13H12V13V12V11H11V10ZM19 12V11H18H17V12V13H18H19V12ZM14 13H15V12V11H14H13V12V13H14Z" style="fill:#', 'glass'];
        bytes memory encoded = abi.encode(accessory);
        return encoded;
    }

    function encodeItems() public pure returns(bytes memory) {
        string[2][2] memory items = [
            ['<path fill-rule="evenodd" clip-rule="evenodd" d="M25 9H24V10H23V11V12H24H25H26V11V10H25V9ZM25 13H24V14H25V13Z" fill="#8DA0A7"/><path fill-rule="evenodd" clip-rule="evenodd" d="M16 13H15V14H16V15H17V16H18V17H19V18H20V19H21H22H23V18H24V17H25V16H26V15V14H25H24H23H22H21V15V16H20V15H19V14H18V13H17H16ZM18 15H17V14H18V15ZM19 16H18V15H19V16ZM20 17H19V16H20V17ZM20 17H21H22V16V15H23H24H25V16H24V17H23V18H22H21H20V17Z" fill="black"/><path fill-rule="evenodd" clip-rule="evenodd" d="M17 14H18V15H17V14ZM19 16H18V15H19V16ZM20 17H19V16H20V17ZM24 15H23H22V16V17H21H20V18H21H22H23V17H24V16H25V15H24Z" style="fill:#', 'pipe'],
            ['<rect x="18" y="13" width="3" height="1" fill="white"/><path fill-rule="evenodd" clip-rule="evenodd" d="M26 9H25V10H24V11H23V13H24V12H25V11H26V9Z" fill="#D9D9D9"/><path fill-rule="evenodd" clip-rule="evenodd" d="M18 13H16V14H18V13ZM22 13H21V14H22V13Z" style="fill:#', 'smoke']
        ];
        bytes memory encoded = abi.encode(items);
        return encoded;
    }

}