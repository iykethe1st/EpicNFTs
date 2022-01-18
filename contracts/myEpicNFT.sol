// SPDX Licence Identifier: Unlicensed

/* first import some openzeppelin Contracts */
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";
import { Base64 } from "./libraries/Base64.sol";

/* we then inherit the contrcat we imported(ERC721URIStorage.sol) */
contract MyEpicNFT is ERC721URIStorage {
  /* magic gven to us by openzeppelin to help us keep tract of token ids */
  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;

  /* This is our SVG code, we need to be able to change the word displayed, everything else remains the same. so we'll create a base SVG variable thate all our NFTs can use */
  string baseSvg = "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 14px; }</style><rect width='100%' height='100%' fill='black' /><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";
/* create arrays, each with their own random words  */
string[] firstWords = ['Active', 'Logical', 'Alert', 'Calm', 'Capable', 'Clean', 'Patient', 'Polished', 'Open', 'Curios', 'Selfless', 'Secure', 'Firm', 'Gallant', 'Humble', 'Suave', 'Subtle', 'Stoic', 'Tidy', 'Sweet'];
string[] secondWords = ['Fat', 'Large', 'Slender', 'Small', 'Thin', 'Tall', 'lanky', 'Petite', 'Buff', 'Broad', 'Ripped', 'Pretty', 'Hot', 'Sexy', 'Cute', 'Rough', 'Plain', 'Flat', 'Wavy', 'Gay', 'Bald', 'Spiky', 'Young', 'Old'] ;
string[] thirdWords= ["Sakai", "Shimura", "Yuna", "Ishikawa", "Masako", "Taka", "Norio", "Kenji", "Yuriko", "Khotunkan", "Ryuzo", "Temuge", "Tomoe", "Mai", "Sogen", "Yasuhira", "Daizo", "Jiro", "Tenzo", "Adachi"];
event NewEpicNFTMinted(address sender, uint256 tokenId);

   /*we need to pass the name of our NFTs token and its symbol  */
  constructor () ERC721 ("SquareNFT", "SQUARE") {
    console.log('Reday to play this game, here lies my NFT Contract! Yeah!');
  }
  /* a function to randomly pick a word from each array */
  function pickRandomFirstWord (uint256 tokenId) public view returns (string memory) {
    /* seed the random generator */
    uint256 rand = random(string(abi.encodePacked("FIRST_WORD", Strings.toString(tokenId))));
    /* squash the # between 0 and the length to avoid goin out of bounds */
    rand = rand % firstWords.length;
    return firstWords[rand];
  }

  function pickSecondWord (uint256 tokenId) public view returns (string memory) {
    uint256 rand = random(string(abi.encodePacked("SECOND_WORD", Strings.toString(tokenId))));
    rand = rand % secondWords.length;
    return secondWords[rand];
  }

  function pickThirdWord (uint256 tokenId) public view returns (string memory) {
    uint256 rand = random(string(abi.encodePacked("THIRD_WORD", Strings.toString(tokenId))));
    rand = rand % thirdWords.length;
    return thirdWords[rand];
  }
  function random(string memory input)internal pure returns (uint256) {
    return uint256(keccak256(abi.encodePacked(input)));
  }
  /* A function our user will hit to get their NFTs */
  function makeAnEpicNFT() public {
    uint256 newItemId = _tokenIds.current();
    /* grab randomly one word from each of the arrays */
    string memory first = pickRandomFirstWord(newItemId);
    string memory second = pickSecondWord(newItemId);
    string memory third = pickThirdWord(newItemId);
    string memory combinedWord = string(abi.encodePacked(first, second, third));
    /* concatenate all the words together the close the <text> and <svg> tags */
    string memory finalSvg = string(abi.encodePacked(baseSvg, combinedWord, "</text></svg>"));
    /* get all the JSON metadata in place and base64 encode it */
    string memory json = Base64.encode(
        bytes(
            string(
                abi.encodePacked(
                    '{"name": "',
                    // We set the title of our NFT as the generated word.
                    combinedWord,
                    '", "description": "A highly acclaimed collection of squares.", "image": "data:image/svg+xml;base64,',
                    // We add data:image/svg+xml;base64 and then append our base64 encode our svg.
                    Base64.encode(bytes(finalSvg)),
                    '"}'
                )
            )
        )

    );

    // Just like before, we prepend data:application/json;base64, to our data.
    string memory finalTokenUri = string(
        abi.encodePacked("data:application/json;base64,", json)
    );
    /* mint NFT to the sender */
    _safeMint(msg.sender, newItemId);
    /* Set the NFTs data */
    _setTokenURI(newItemId, finalTokenUri);
    console.log("An NFT w/ %s ID has been minted to %s", newItemId, msg.sender);
    console.log("\n--------------------");
    console.log(string(abi.encodePacked("https://nftpreview.0xdev.codes/?code=", finalTokenUri)));
    console.log("--------------------\n");
    /* Increment thhe counter for when the next NFT is minted */
    _tokenIds.increment();
    emit NewEpicNFTMinted(msg.sender, newItemId);
  }

}
