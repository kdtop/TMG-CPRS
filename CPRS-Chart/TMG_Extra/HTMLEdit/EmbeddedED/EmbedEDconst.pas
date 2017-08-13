{ ******************************************** }
{       EmbedEDconst ver 1.1 (Jan. 16, 2004)   }
{                                              }
{       For Delphi 4, 5 and 6                  }
{                                              }
{       Copyright (C) 1999-2003, Kurt Senfer.  }
{       All Rights Reserved.                   }
{                                              }
{       Support@ks.helpware.net                }
{                                              }
{       Documentation and updated versions:    }
{                                              }
{       http://KS.helpware.net                 }
{                                              }
{ ******************************************** }
{
    This library is free software; you can redistribute it and/or
    modify it under the terms of the GNU Lesser General Public
    License as published by the Free Software Foundation; either
    version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
    Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public
    License along with this library; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
}

unit EmbedEDconst;

interface
  uses windows, messages;

const

  {the old DECMD_... comands starts with
    DECMD_BOLD              = IDM_BOLD;     //5000

  and ends with
    DECMD_PROPERTIES        = $000013BC;    //5052

  most MS constants is defined in the area from 0 to 24..
  and the suddenly some in the 37.. rang.
  There is a few 60.. and 32...

  It seems safe to continue the old 5000 series a bit }

  //start special IDM_... commands
  IDM_NUDGE_ELEMENT       = 5053;
  IDM_CONSTRAIN           = 5055;

  KS_TEST                 = 5056;
  IDM_LocalUndoManager    = 5057;

  IDM_SHOW_BOOKMARKS      = 5058;
  IDM_SHOW_PAGEBRKS       = 5059;
  IDM_SHOW_REVISIONS      = 5060;
  IDM_DROP_UNDO_PACKAGE   = 5061;
  IDM_DROP_ReDO_PACKAGE   = 5062;
  IDM_STRIPCELLFORMAT     = 5063;
  IDM_RestoreSystemCursor = 5064;


  WaitAsync_MESSAGE = WM_USER + 210;

implementation

//------------------------------------------------------------------------------
end.
