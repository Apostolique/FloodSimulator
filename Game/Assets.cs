using FontStashSharp;
using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Content;
using Microsoft.Xna.Framework.Graphics;

namespace GameProject {
    public static class Assets {
        public static void Setup(ContentManager content) {
            LoadRenderTargets();
            LoadShaders(content);
        }

        public static void LoadFonts(ContentManager content, GraphicsDevice graphicsDevice) {
            FontSystem = FontSystemFactory.Create(graphicsDevice, 2048, 2048);
            FontSystem.AddFont(TitleContainer.OpenStream($"{content.RootDirectory}/source-code-pro-medium.ttf"));
        }
        public static void LoadRenderTargets() {
            Seed = new RenderTarget2D(Global.Game.GraphicsDevice, Global.Game.Window.ClientBounds.Width, Global.Game.Window.ClientBounds.Height, false, SurfaceFormat.Color, DepthFormat.None, 0, RenderTargetUsage.PreserveContents);
            Solution = new RenderTarget2D(Global.Game.GraphicsDevice, Global.Game.Window.ClientBounds.Width, Global.Game.Window.ClientBounds.Height);
        }
        public static void LoadShaders(ContentManager content) {
            Grow = content.Load<Effect>("grow");
            Brown = content.Load<Effect>("brown");
            Edge = content.Load<Effect>("edge");

            var w = Global.Game.Window.ClientBounds.Width;
            var h = Global.Game.Window.ClientBounds.Height;

            Grow.Parameters["unit"].SetValue(new Vector2(1f / w, 1f / h));
            Edge.Parameters["unit"].SetValue(new Vector2(1f / w, 1f / h));
            if (w < h) {
                Brown.Parameters["ratio"].SetValue(new Vector2(w / (float)h, 1f));
            } else {
                Brown.Parameters["ratio"].SetValue(new Vector2(1f, h / (float)w));
            }
        }

        public static FontSystem FontSystem = null!;
        public static Effect Grow = null!;
        public static Effect Brown = null!;
        public static Effect Edge = null!;
        public static RenderTarget2D Seed = null!;
        public static RenderTarget2D Solution = null!;
    }
}
