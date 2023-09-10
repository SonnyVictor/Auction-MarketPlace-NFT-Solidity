// SPDX-License-Identifier: MIT
pragma solidity >=0.8.15;

contract EncodeCharacterContract {
   
   function encodeCharacter() public pure returns (bytes memory) {
        string[2][9] memory spaceship = [
            [   '<path fill-rule="evenodd" clip-rule="evenodd" d="M72 44H69V45V46V47V48H72V47H70V46V45H72V44ZM76 44H79V45V46V47V48H76V47H78V46V45H76V44Z" fill="white"/><path fill-rule="evenodd" clip-rule="evenodd" d="M70 45H72V47H70V45ZM78 45H76V47H78V45ZM70 49H71V50H70V49ZM71 50H75V51H71V50Z" fill="black"/><path fill-rule="evenodd" clip-rule="evenodd" d="M78 38H70V39H67V40H70V39H78V40H81V39H78V38ZM66 42H67V43H66V42ZM73 42H75V43V44H73V43V42ZM82 42H81V43H82V42Z" fill="#7F6C49"/><path fill-rule="evenodd" clip-rule="evenodd" d="M64 40H65H66V41V42H65V43H64V42V41V40ZM69 43H67V51H69V53H76H79V51H81V43H79V48H76V44H72V48H69V43ZM70 50V49H71V50H70ZM71 50H72H75V51H71V50ZM83 40H84V41V42V43H83V42H82V41V40H83Z" fill="#D8B3A9"/><path fill-rule="evenodd" clip-rule="evenodd" d="M70 37H78V38H70V37ZM67 39V38H70V39H67ZM66 42H67V41V40V39H66H65H64V40H63V41V42V43H64V44H65V53H66V54H67V55H69V56H79V55H81V54H82V53H83V44H84V43H85V42V41V40H84V39H83H82H81V38H78V39H81V40V41V42H82V53H81V54H79V55H69V54H67V53H66V42ZM82 42H83V43H84V42V41V40H83H82V41V42ZM66 42V41V40H65H64V41V42V43H65V42H66ZM73 42H69V43V44H73V43V42ZM79 42H75V43V44H79V43V42Z" fill="#332B1E"/><path fill-rule="evenodd" clip-rule="evenodd" d="M70 39H78V40H81V41V42V43H79V42H69V43H67V42V41V40H70V39ZM79 52V53H69V52V51H67V43H66V51V52V53H67V54H69V55H79V54H81V53H82V52V51V43H81V51H79V52ZM78 56H70V57H78V56Z" style="fill:#',
                "Monkey"
            ],
            [
                '<path fill-rule="evenodd" clip-rule="evenodd" d="M72 46H73V47H72V46ZM78 46H79V47H78V46ZM83 49H84V50H85V49V48H84H83V49Z" fill="black"/><path fill-rule="evenodd" clip-rule="evenodd" d="M72 45H71V46V47V48H72H73V47H72V46H73V45H72ZM79 45H78V46H79V47H78V48H79H80V47V46V45H79Z" fill="white"/><path fill-rule="evenodd" clip-rule="evenodd" d="M70 40H69V41H68V42H67V50H68V51V53H69V51V50H68V42H69V41H70H71H72H73H74H75H76H77H78H79H80H81V42H82V41H81V40H80H79H78H77H76H75H74H73H72H71H70ZM70 53H71V54H70V53ZM76 44H77V45H78V46V47V48H77H76H75H74H73V47V46V45H74V44H75H76ZM70 45H71V46V47V48H70V47V46V45ZM80 45H81V46V47V48H80V47V46V45Z" fill="#B26C37"/><path fill-rule="evenodd" clip-rule="evenodd" d="M67 37H68H69V38H68V39V40V41V42H67V41V40V39V38V37ZM67 50H66V49V48V47V46V45V44V43V42H67V43V44V45V46V47V48V49V50ZM68 53H67V50H68V53ZM70 54H68V53H70V54ZM71 55H70V54H71V55ZM79 55V56H78H77H76H75H74H73H72H71V55H72H73H74H75H76H77H78H79ZM81 54V55H80H79V54H80H81ZM82 52V53V54H81V53V52H82ZM83 51V52H82V51H83ZM83 51V50H84V51H83ZM70 39V38H69V39H70ZM76 39H70V40H76H77H78H79H80V39H81V38H82V39V40V41V42H83V43V44V45V46V47V48H82H81V49H82H83V48H84V47V46V45V44V43V42H83V41V40V39V38V37H82H81V38H80V39H79H78H77H76ZM74 53V52H73V53H74ZM74 53V54H78V53H74ZM71.9999 45V44H71H70V45H70.9999H71.9999ZM73.9999 48V49H73H72H71H70V48H71H72H72.9999H73.9999ZM75 48H73.9999V49H75H75.9999H76.9999V48H76H75ZM78.9999 48V49H78H76.9999V48H77.9999H78.9999ZM78.9999 45V44H78H77V45H77.9999H78.9999ZM73.9999 44V45H73H71.9999V44H72.9999H73.9999ZM81 48V49H80H78.9999V48H79.9999H81ZM80.9999 45V44H80H78.9999V45H79.9999H80.9999Z" fill="#662800"/><path fill-rule="evenodd" clip-rule="evenodd" d="M68 38H69V39H70V40H69V41H68V40V39V38ZM81 41V42H83V44V48H81V44H70V45V46V47V48V49H71H72H73H74H75H76H84V50H83V51H82V52H81V53V54H79V55H71V54V53H70H69V51V50H68V44V42H69V41H70H71H72H73H74H75H76H77H78H79H80H81ZM81 41H82V40V39V38H81V39H80V40H81V41ZM78 54V53H74V52H73V53H74V54H78ZM79 56V57H71V56H79Z" style="fill:#',
                "Fox"
            ],
            [
                '<path fill-rule="evenodd" clip-rule="evenodd" d="M73 46H71V47V48V49H73V48H72V47H73V46ZM77 46H79V47V48V49H77V48H78V47H77V46Z" fill="white"/><path fill-rule="evenodd" clip-rule="evenodd" d="M72 47H73V48H72V47ZM74 49H76V51H74V49ZM77 47H78V48H77V47Z" fill="black"/><path fill-rule="evenodd" clip-rule="evenodd" d="M70 42H69V43H68V44H69V48H68V51H69V48H70V44H80V43H81V44H82V43H81V42H80V43H70V42ZM70 43V44H69V43H70ZM81 48H82V51H81V50H76V49H81V48ZM74 49H70V50H74V49ZM71 45H74V46H71V45ZM79 45H76V46H79V45Z" fill="#90A6AF"/><path fill-rule="evenodd" clip-rule="evenodd" d="M70 40H66V41V44H67V45H68V46V47V48H67V49V50V51H68V53H69V55H70V56H78H80V55H81V53H82V51H83V50V49V48H82V47V46V45H83V44H84V41V40H80V41H79V42H71V41H70V40ZM70 43V41H67V44H69V45V46V47V48H68V49V50V51H69V53H70V55H78H80V53H81V51H82V50V49V48H81V47V46V45V44H83V41H80V43H79H71H70ZM70 43V44H69V43H70ZM80 43V44H81V43H80ZM71 52H72V53H71V52ZM72 53H76V54H72V53Z" fill="#35444C"/><path fill-rule="evenodd" clip-rule="evenodd" d="M68 41H67V42V43V44H68V43H69V42H70V41H69H68ZM70 44H81V45V49H80H79V45H76V46H77V47V48V49H73V48V47V46H74V45H71V49H70V50H74V51H76V50H81V51V52V53H80V54V55H70V54V53H69V52V51V48H70V45V44ZM76 54V53H72V52H71V53H72V54H76ZM81 41H80V42H81V43H82V44H83V43V42V41H82H81ZM79 56H71V57H79V56Z" style="fill:#',
                "Dog"
            ],
            [
                '<path fill-rule="evenodd" clip-rule="evenodd" d="M73 47H71V48V49V50H73V49H72V48H73V47ZM77 47H79V48V49V50H77V49H78V48H77V47Z" fill="white"/><path fill-rule="evenodd" clip-rule="evenodd" d="M67 43H66V44H67V43ZM83 43H84V44H83V43Z" fill="#7F6C49"/><path fill-rule="evenodd" clip-rule="evenodd" d="M72 48H73V49H72V48ZM78 48H77V49H78V48ZM76 50H74V51H76V50Z" fill="black"/><path fill-rule="evenodd" clip-rule="evenodd" d="M71 45H70V46H69V51V52H70H71V51H72V50H71V46H74V47H73V48V49H77V48V47H76V46H79V50H78V51H79V52H80H81V51V50V46H80V45H79H71ZM75 51H74V52H73V53H74H75H76H77V52H76V51H75ZM73 54H74H75H76H77H78H79V55H78H77H76H75H74H73H72H71V54H72H73ZM79 57V56H71V57H79Z" fill="#C2974B"/><path fill-rule="evenodd" clip-rule="evenodd" d="M65 41H68V42H65V41ZM65 45H64V42L65 42V45ZM67 46H65V45H67V46ZM68 52H67L67 46H68L68 52ZM69 54H68L68 52H69V54ZM71 54H69V55H71V56H79V55H81V54H82V52H83V46H85V45H86V42L85 42V41H82V42H80V41H70V42H68V43H70V42H80V43H82V42H85V45H83V46H82V52H81V54H79V53V52V51H78V50H77V49H73V50H72V51H71V52V53V54ZM72 51H73V50H77V51H78V52V53H77H76H75H74H73H72V52V51ZM71 54V55H79V54H78H77H76H75H74H73H72H71ZM71 46H74V47H71V46ZM76 46H79V47H76V46Z" fill="#423419"/><path fill-rule="evenodd" clip-rule="evenodd" d="M65 42H68V43H70V42H80V43H82V42H85V43V44V45H83V46H82V52H81V46H80V45H70V46H69V50V52H68V50V46H67V45H65V44V43V42ZM66 44H67V43H66V44ZM69 52H71V53V54H69V53V52ZM81 52V53V54H79V53V52H81ZM84 43V44H83V43H84ZM72 51H73V50H74V51V52H73V53H72V52V51ZM78 53V52V51H77V50H76V51V52H77V53H78Z" style="fill:#',
                "Bear"
            ],
            [
                '<path fill-rule="evenodd" clip-rule="evenodd" d="M72 47H71V48H72V47ZM77 47H76V48H77V47Z" fill="black"/><path fill-rule="evenodd" clip-rule="evenodd" d="M72 46H70V47V48V49H72V48H71V47H72V46ZM77 48V47H76V46H78V47V48V49H76V48H77Z" fill="white"/><path fill-rule="evenodd" clip-rule="evenodd" d="M68 41H69V42H68V43H67V42V41H68ZM68 43H69V44H68V43ZM68 51H67V52H68V51ZM80 51H81V52H80V51ZM80 53H81V54H80V53ZM79 41H80H81V42V43H80V42H79V41ZM80 43V44H79V43H80ZM67 45H68V50H67V45ZM81 45H80V50H81V45ZM67 53H68V54H67V53ZM78 42H70V43H78V42ZM70 44H78V45H76V46V47V48H72V47V46V45H70V44ZM70 45V49H73V50V51H71V50H70H69V45H70ZM78 50H79V45H78V49H75V50V51H77V50H78Z" fill="#AF6A34"/><path fill-rule="evenodd" clip-rule="evenodd" d="M68 38H67V39H66V40H65V45H66V54H67V53H68V52H67V51H68V50H67V45H68V43H70V42H78V43H80V45H81V50H80V51H81V52H80V53H81V54H82V45H83V40H82V39H81V38H80H79V39V40H78V41H70V40H69V39V38H68ZM69 40V41H70V42H68V43H67V45H66V40H67V39H68V40H69ZM78 41H79V40H80V39H81V40H82V45H81V43H80V42H78V41ZM69 54H68V55H69H70V56H78V55H79H80V54H79H78V55H70V54H69ZM69 51H70V52H69V51ZM70 52H74V53H70V52ZM72 45H70V46H72V45ZM72 48H76V49H75V50H73V49H72V48ZM76 45H78V46H76V45Z" fill="#33240A"/><path fill-rule="evenodd" clip-rule="evenodd" d="M68 39H67V40H66V41V42V43V44V45H67V44V43V42V41H68H69V42H70V41H69V40H68V39ZM70 56V57H78V56H70ZM81 39H80V40H79V41H78V42H79V41H80H81V42V43V44V45H82V44V43V42V41V40H81V39ZM79 43H69V44H68V45V50V51V52V53V54H70V55H78V54H80V53V52V51V50V45V44H79V43ZM79 45H78V44H70V45H69V50H70H71V51H73V50H74H75V51H77V50H78H79V45ZM70 52H74V53H70V52ZM70 52H69V51H70V52Z" style="fill:#',
                "Tiger"
            ],
            [
                '<path fill-rule="evenodd" clip-rule="evenodd" d="M72 47H71V48V49V50H72H73V49H72V48H73V47H72ZM78 47H79V48V49V50H78H77V49H78V48H77V47H78Z" fill="white"/><path fill-rule="evenodd" clip-rule="evenodd" d="M73 48H72V49H73V48ZM77 48H78V49H77V48ZM75 50H76V51V52H75H74V51V50H75Z" fill="black"/><path fill-rule="evenodd" clip-rule="evenodd" d="M76 44H74V45H68V46H69V47H70V46H74V47H76V46H80V47H81V46H82V45H76V44Z" fill="#996A44"/><path fill-rule="evenodd" clip-rule="evenodd" d="M69 44H67V45V46V47H68V48H70V47H69V46H68V45H69V44ZM81 44H83V45V46V47H82V48H80V47H81V46H82V45H81V44ZM72 46H73V47H72H71V46H72ZM79 46H78H77V47H78H79V46ZM72 50H73V49V48H74V49V50V51V52H73V51H72H71V50H72ZM76 52V53H75H74V52H75H76ZM76 52V51V50V49V48H77V49V50H78H79V51H78H77V52H76Z" fill="#D8B697"/><path fill-rule="evenodd" clip-rule="evenodd" d="M67 43H69V44H67V47H66V44V43H67ZM68 48H67V47H68V48ZM82 48V49H81V56H80H79V57H78V56H72V57H71V56H70H69V49H68V48H70V49V55H71H72H78H79H80V49V48H82ZM83 47H82V48H83V47ZM83 44V47H84V44V43H83H81V44H76V43H74V44H69V45H74V44H76V45H81V44H83Z" fill="#3F2917"/><path fill-rule="evenodd" clip-rule="evenodd" d="M72 34V36V37H73V38L73 44H72V41H70V40H72V38H71V37H67V36H71V34H72ZM79 36H83V37H79V38H78V40H80V41H78V44H77V38V37H78V36V34H79V36Z" fill="#9E7A3D"/><path fill-rule="evenodd" clip-rule="evenodd" d="M70 33H71H72V34H71V35V36H70H69H68H67V37H66V36V35H67H68H69H70V34V33ZM71 38H70H67V37H70H71V38ZM70 41H69V40V39H70H71V38H72V39V40H71H70V41ZM70 41H71H72V44H71V42H70V41ZM73 37H72V36V35V34H73V35V36V37ZM73 37H74V38V39V44H73V39V38V37ZM78 41H79H80V42H79V44H78V41ZM79 38V39H80H81V40V41H80V40H79H78V39V38H79ZM80 37H79V38H80H83V37H84V36V35H83H82H81H80V34V33H79H78V34H77V35V36V37H76V38V39V44H77V39V38V37H78V36V35V34H79V35V36H80H81H82H83V37H80Z" fill="#423419"/><path fill-rule="evenodd" clip-rule="evenodd" d="M70 46H71V51H73V52H74V53H76V52H77V51H79V46H80V55H79H71H70V46ZM74 46H73V47V48H74V49V50H75H76V49V48H77V47V46H76V47H75H74V46ZM78 57V56H72V57H78Z" style="fill:#',
                "Deer"
            ],
            [
                '<path fill-rule="evenodd" clip-rule="evenodd" d="M73 45H74H75V46V47H74H73V46V45ZM80 45H79H78V46V47H79H80V46V45Z" fill="black"/><path fill-rule="evenodd" clip-rule="evenodd" d="M83 42H82V43V44V45V46V47H83V46V45V44H84V45V46V47V48H83V49H82V50V51V52H81V53V54H80V55H79H78H77H76H75H74H73H72H71H70V54H69V53V52H68V51V50H69V49H68H67V48H66V47V46V45V44H65V45V46V47V48H66V49H67V50V51V52H68V53V54H69V55H70V56H71H72H73H74H75H76H77H78H79H80V55H81V54H82V53V52H83V51V50V49H84V48H85V47V46V45V44H84V43H83V42ZM72 49H73V50H72V49ZM74 50H73V51H74H75H76H77V50H76H75H74Z" fill="#A94D00"/><path fill-rule="evenodd" clip-rule="evenodd" d="M74 38H73V39H72H71V40H72H73V41H74H75V40H76H77V41H78H79H80V40H81V41H82V40H81V39V38H80H79H78H77H76H75H74ZM80 39V40H79V39H80ZM75 40H74V39H75V40Z" fill="#FECB6F"/><path fill-rule="evenodd" clip-rule="evenodd" d="M68 35H67V36V37H66V38V39H67V40H66V41V42V43V44H67H68V45V46H69V45H70V44V43V42H71V41H72H73V42H74H75V41H76H77V42H78H79H80V41H81V42H82H83V41V40H82V39H83V38V37H82V36H81H80H79V35H78H77H76H75H74H73H72H71V36H70H69V35H68ZM69 36V37H70H71V36H72H73H74H75H76H77H78H79V37H80H81V38H82V39H81V40H80V39H79V40H80V41H79H78H77V40H76H75V39H74V40H75V41H74H73V40H72H71V39H70V40H71V41H70H69V42V43V44H68V43H67V42V41V40H68V39H67V38H68V37V36H69ZM81 40V41H82V40H81ZM73 43H74H75H76V44H75H74H73V43ZM80 43H79H78V44H79H80H81V43H80Z" fill="#A56A04"/><path fill-rule="evenodd" clip-rule="evenodd" d="M71 41H72H73V42H72H71V41ZM71 42V43V44V45V46V47V48V49V50V51V52V53H72V54H73H74V55H73H72H71H70V54H69V53V52H68V51V50H69V49H68H67V48H66V47V46V45V44H67H68V45V46H69V45H70V44V43V42H71ZM72 56H73H74H75H76H77H78H79V57H78H77H76H75H74H73H72H71V56H72ZM74 52H75H76V53H75H74V52ZM75 41H76H77V42H76H75V41ZM80 41H81V42H80V41ZM84 44H83V45V46V47H82H81H80H79H78H77H76H75H74H73H72V48H73H74H75H76H77H78H79H80H81H82V49H83V48H84V47V46V45V44Z" fill="#FF9A4F"/><path fill-rule="evenodd" clip-rule="evenodd" d="M71 42H72H73H74H75H76H77H78H79H80H81H82V43V44V45V46V47H81H80V46V45H79H78V46V47H77H76H75V46V45H74H73V46V47H72V48H73H74H75H76H77H78H79H80H81H82V49V50V51V52H81V53V54H80V55H79H78H77H76H75H74V54H73H72V53H71V52V51V50V49V48V47V46V45V44V43V42ZM76 53V52H75H74V53H75H76ZM77 51V50H76H75H74H73V49H72V50H73V51H74H75H76H77ZM81 44V43H80H79H78V44H79H80H81ZM76 43H75H74H73V44H74H75H76V43Z" fill="#FFB882"/><path fill-rule="evenodd" clip-rule="evenodd" d="M73 36H74H75H76H77H78H79V37H80H81V38H80H79H78H77H76H75H74H73V39H72H71H70V40H71V41H70H69V42V43V44H68V43H67V42V41V40H68V39H67V38H68V37V36H69V37H70H71V36H72H73ZM81 38H82V39H81V38Z" style="fill:#',
                "Human"
            ],
            [
                '<path fill-rule="evenodd" clip-rule="evenodd" d="M69 49H68V53H69V49ZM82 49H81V53H82V49Z" fill="#CCCCCC"/><path fill-rule="evenodd" clip-rule="evenodd" d="M73 41V40H70L70 41H69V48H70L70 41L73 41ZM77 41V42H73V41L77 41ZM80 41H77V40H80V41ZM80 41V48H81V41H80ZM76 44V43H74V44H76ZM77 47V48H73V47H77Z" fill="#727F7D"/><path fill-rule="evenodd" clip-rule="evenodd" d="M71 32H74V33H71V32ZM70 34V33H71V34H70ZM69 41V34H70V41H69ZM81 41V48H69V41H68V48V49H67V53H68V54H70V55H71V57H72V55H78V57H79V55H80V54H82V53H83V49H82V48V41H81ZM81 36V41H80V36H81ZM82 35V36H81V35H82ZM82 33H83V35H82V33ZM79 33H82V32H79V33ZM78 34V33H79V34H78ZM77 40V34H78V40H77ZM73 40H77V41H73V40ZM73 36V40H72V36H73ZM74 35V36H73V35H74ZM74 35H75V33H74V35ZM82 49V53H80V54H70V53H68V49H82ZM71 50H70V51H71V52H75V51H71V50ZM71 43H74V44H71V43ZM79 43H76V44H79V43Z" fill="#283331"/><path fill-rule="evenodd" clip-rule="evenodd" d="M73 45H72V46V47H73V46V45ZM77 45H78V46V47H77V46V45Z" fill="black"/><path fill-rule="evenodd" clip-rule="evenodd" d="M74 34H73H72V35H71V36V37V38V39V40H72V39V38V37V36H73V35H74V34ZM78 57V55H72V57H78ZM81 34H82V35H81V36H80V37V38V39V40H79V39V38V37V36V35H80V34H81ZM73 45V44H71V45V46V47V48H73V47H72V46V45H73ZM79 44H77V45H78V46V47H77V48H79V47V46V45V44ZM81 49H69V50V51V52V53H70V54H80V53H81V52V51V50V49ZM70 51H71V52H75V51H71V50H70V51Z" fill="white"/><path fill-rule="evenodd" clip-rule="evenodd" d="M71 33H72H73H74V34H73H72V35H71V40H70V34H71V33ZM71 41H70V48H71V43H79V48H80V43V42V41H77V42H73V41H71ZM77 47V44H73L73 47H77ZM79 34H78V40H79V35H80V34H81H82V33H81H80H79V34Z" style="fill:#',
                "Rabbit"
            ],
            [
                '<path fill-rule="evenodd" clip-rule="evenodd" d="M74 46H73H72V47V48V49H73H74V48H73V47H74V46ZM77 46H78H79V47V48V49H78H77V48H78V47H77V46Z" fill="white"/><path fill-rule="evenodd" clip-rule="evenodd" d="M74 47H73V48H74V47ZM78 47H77V48H78V47Z" fill="black"/><path fill-rule="evenodd" clip-rule="evenodd" d="M73 39H77V40H79V41H80V42V43H78V44H73V43H71V44H70V51V53V54H69V53H68V51V49H69V48H68V46H69V44V43H70V42V41H71V40H73V39ZM71 55V54H70V55H71ZM71 55V56H79V55H71ZM79 51V50H80V46H79V49H78H77V48V47V46H76H75H74V47V48V49H73H72V46H71V50H72V51H73V52H78V51H79ZM74 49H75V50H74V49ZM77 49V50H76V49H77ZM82 46H81V48H82V46ZM81 49H82V53H81V49Z" fill="#828282"/><path fill-rule="evenodd" clip-rule="evenodd" d="M72 38H78V39H79V40H77V39H73V40H71V39H72V38ZM70 41V40H71V41H70ZM69 43V41H70V43H69ZM68 46V43H69V46H68ZM68 53H67V46H68V48H69V49H68V53ZM69 54H68V53H69V54ZM70 55H69V54H70V55ZM71 56H70V55H71V56ZM79 56V57H71V56H79ZM80 55V56H79V55H80ZM81 54V55H80V54H81ZM82 53V54H81V53H82ZM82 46H83V53H82V49H81V48H82V46ZM81 44V46H82V43H81V41H80V40H79V41H80V44H81ZM71 52H72V53H71V52ZM72 53H76V54H72V53ZM74 49H75V50H74V49ZM77 49H76V50H77V49ZM80 45H71V46H80V45Z" fill="#3F3F3F"/><path fill-rule="evenodd" clip-rule="evenodd" d="M73 43H71V44H70V45V51V54H71V55H80V54H81V53V52V51V45V44H80V43H78V44H73V43ZM72 51H73V52H78V51H79V50H80V45H71V50H72V51ZM76 54V53H72V52H71V53H72V54H76Z" style="fill:#',
                "Gorilla"
            ]
        ];
        bytes memory encoded = abi.encode(spaceship);
        return encoded;
    }

}
