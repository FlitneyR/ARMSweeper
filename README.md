# ARMSweeper
A simple game of mine sweeper in Aarch64 assembly

## Custom Data types:

The board is a 100 byte array. Every row is 10 bytes long
and the last cell on each row has the EOR (End of row)
flag set.

Cell:
<table>
    <tr>
        <th>1</th>
        <th>2</th>
        <th>3</th>
        <th>4</th>
        <th>5</th>
        <th>6</th>
        <th>7</th>
        <th>8</th>
    </tr>
    <tr>
        <td> End of row </td>
        <td> Revealed </td>
        <td> Flagged </td>
        <td> Bomb </td>
        <td colspan=4>
            Adjacent Bomb Count
        </td>
    </tr>
</table>